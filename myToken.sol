pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract myToken {

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    struct tokenApartament {
        string streetAndNumber;
        uint16 square;
        uint8 rooms;
    }

    tokenApartament[] tokensArr;
    mapping (uint => uint) tokenToOwner;
    mapping (uint => uint) tokenToCost;
    modifier checkOwner() {
        require(msg.pubkey() == tvm.pubkey(), 102);
        for (uint256 index = 0; index < tokensArr.length; index++) {
            require(msg.pubkey() == tokenToOwner[index], 403);
        }
        tvm.accept();
        _;
    }

    function createToken(string streetAndNumber, uint16 square, uint8 rooms) public {
        require(msg.pubkey() == tvm.pubkey(), 102);
        for (uint256 index = 0; index < tokensArr.length; index++) {
            require(tokensArr[index].streetAndNumber != streetAndNumber, 404);
        }
        tvm.accept();
        tokensArr.push(tokenApartament(streetAndNumber, square, rooms));
        uint keyAsLastNum = tokensArr.length - 1;
        tokenToOwner[keyAsLastNum] = msg.pubkey();
    }
    function upForSale(string streetAndNumber, uint cost) public checkOwner{
        for (uint256 index = 0; index < tokensArr.length; index++) {
            if (tokensArr[index].streetAndNumber == streetAndNumber){
                tokenToCost[index] = cost;
                break;
            }
        }
    }
}
