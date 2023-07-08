//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/token/ERC721/ERC721Upgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/contracts/utils/CountersUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";

contract Game is
    Initializable,
    ERC721Upgradeable,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    event MonsterGenerated(address, uint256);
    event Winner(address);
    event Looser(address);

    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter public tokenId;
    CountersUpgradeable.Counter public monsterId;

    enum State {
        win,
        loss
    }

    enum Status {
        free,
        engaged
    }

    string public baseUri;
    uint256 internal timeSet;

    mapping(address => uint256) public addressToMonsterId;
    mapping(uint256 => address) public monsterIdToAddress;
    mapping(uint256 => bool) public presentInMonsters;
    mapping(uint256 => Status) public status;
    mapping(address => mapping(uint256 => State)) public state;
    mapping(uint256 => bool) public monsterReadyToAttack;

    function initialize() public initializer {
        __ERC721_init("GAME", "GM");
        __Ownable_init();
         __UUPSUpgradeable_init();
    }

    function setbaseUri(string memory _baseUri) public onlyOwner {
        baseUri = _baseUri;
    }

    function mint(address _address) internal {
        tokenId.increment();
        uint256 currentTokenId = tokenId.current();
        _safeMint(_address, currentTokenId);
        tokenURI(currentTokenId);
    }

    function generateMonster() public payable {
        require(addressToMonsterId[msg.sender] == 0);
        require(msg.value == 0.01 ether, "Pay 0.01 ether to mint a monster!");
        monsterId.increment();
        uint256 currentTokenId = monsterId.current();

        _safeMint(msg.sender, currentTokenId);
        addressToMonsterId[msg.sender] = currentTokenId;
        monsterIdToAddress[currentTokenId] = msg.sender;
        presentInMonsters[currentTokenId] = true;

        status[currentTokenId] = Status.free;
        monsterReadyToAttack[currentTokenId] = true;
        emit MonsterGenerated(msg.sender, currentTokenId);
    }

    function attack(uint256 _enemyTokenId) public payable {
        require(
            msg.value == 0.01 ether,
            "Please pay 0.01 ether to start an attack"
        );
        address winner;
        address looser;
        uint256 _attackerTokenId = addressToMonsterId[msg.sender];
        require(monsterReadyToAttack[_attackerTokenId] == true);
        uint256 number = generateNumber();
        if (number > 50) {
            state[msg.sender][_attackerTokenId] = State.win;
            looser = monsterIdToAddress[_enemyTokenId];
            state[looser][_enemyTokenId] = State.loss;
            mint(msg.sender);
        } else {
            state[msg.sender][_attackerTokenId] = State.loss;
            winner = monsterIdToAddress[_enemyTokenId];
            state[winner][_enemyTokenId] = State.loss;
            mint(winner);
        }

        status[_enemyTokenId] = Status.free;
        status[_attackerTokenId] = Status.free;
        timeSet = block.timestamp + 1 hours;
        monsterReadyToAttack[_attackerTokenId] = false;
        coolDown(_attackerTokenId);

        emit Winner(winner);
        emit Looser(looser);
    }

    function chooseOpponent(uint256 _enemyTokenId) public {
        uint256 _attackerTokenId = addressToMonsterId[msg.sender];
        require(
            status[_enemyTokenId] == Status.free &&
                status[_attackerTokenId] == Status.free
        );

        require(
            presentInMonsters[_enemyTokenId] &&
                presentInMonsters[_attackerTokenId]
        );
        status[_enemyTokenId] = Status.engaged;
        status[_attackerTokenId] = Status.engaged;
    }

    function generateNumber() private view returns (uint256) {
        uint256 nonce = 1;
        uint256 number = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))
        ) % 100;
        nonce++;
        return number + 1;
    }

    function coolDown(uint256 _tokenId) internal waitTillCoolingDown {
        monsterReadyToAttack[_tokenId] = true;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseUri;
    }

    function withdraw() public onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Payment failed");
    }

    modifier waitTillCoolingDown() {
        require(block.timestamp > timeSet);
        _;
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal virtual override onlyOwner {}

    /**
     * @dev implementation contract must include upgradeTo()
     * @param newImplementation address
     */

    function upgradeTo(
        address newImplementation
    ) public virtual override onlyProxy onlyOwner{
        _authorizeUpgrade(newImplementation);
        _upgradeToAndCallUUPS(newImplementation, new bytes(0), false);
    }
}

// https://sepolia.etherscan.io/address/0xa596a550c9a2c3f22bb56a3582a5d8bc0feeb522