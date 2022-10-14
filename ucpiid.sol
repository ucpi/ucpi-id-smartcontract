// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/utils/Strings.sol";
contract ucpinaming{
    //main ucpi mapping
    mapping(string=>string) public mainid;
    //check if wallet exist
    mapping(string=>bool) public idexist;
    //primary wallet of id
    mapping(string=>string) public primarywallet;
    //wallet name address mapping 
    mapping(string=>string) public wallet;
    //sub wallets linked with id
    mapping(string=>string) public walletsubwallet;
    //number of wallet linked with id count
    mapping(string=>uint) public numofwallet;
    //mapping of id owner
    mapping(string=>address) public idowner;
    //mapping of wallet owner address
     mapping(string=>address) public  walletowner;
     //mapping of wallet existance
    mapping(address=>uint) public walletownercount;
    //number of ucpiid made by an address by default is 2 for more need to pay 151 harmony per id
    mapping(address=>bool) public ispremium;
    //account that has more than 2 ucpiid 
    mapping(string=>uint) public idprice;
    //resell price of the ucpi id
    mapping(string=>string) public subwalletnum;
    //number to subwallet mapping
    mapping(uint=>string) public joiningnum;
    //joining order
    uint public usercount=0;
    //number of user  
      uint public resellcount=0;
    //number of user  
    address public ucpimultisign=0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    function createid(string memory _id,string memory _brand,string memory _address,string memory _walletname,bytes memory sign,uint256 idp) external {
        _id=validate(_id);
           bytes32 wlcmhash=0x894717e02bc1017f7347665a198b3cb74671478407a02a65b750d7e88f8f8570;
          bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(sign);
        bytes32 prefixedHashMessage = keccak256(abi.encodePacked(prefix,wlcmhash));
         
        address wa=ecrecover(prefixedHashMessage, v, r, s);
        
        require(keccak256(abi.encodePacked("ucpi"))==keccak256(abi.encodePacked(_brand)),"no custom brands allowed");
        _walletname=validate(_walletname);
        
         if(ispremium[wa]==false){
           require(walletownercount[wa]<=1,"free tier complete please purchase premium ");
         }  
         else{ 
         }
          
         require(idexist[string(abi.encodePacked(_id,"@",_brand))]==false,"id not present");
      //require(&&idexist[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=false,"wall")
        mainid[string(abi.encodePacked(_id,"@",_brand))]=_address;
        walletsubwallet[string(abi.encodePacked(_id,"@",_brand))]=string(abi.encodePacked(_id,"@",_brand,"$",_walletname));
        numofwallet[string(abi.encodePacked(_id,"@",_brand))]+=1;
        wallet[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=_address;
        idexist[string(abi.encodePacked(_id,"@",_brand))]=true;
        primarywallet[string(abi.encodePacked(_id,"@",_brand))]=_walletname;
        idexist[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=true;
        idowner[string(abi.encodePacked(_id,"@",_brand))]=wa;
        walletowner[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=wa;
        idprice[string(abi.encodePacked(_id,"@",_brand))]=idp;
        walletownercount[wa]+=1;
       uint m=numofwallet[string(abi.encodePacked(_id,"@",_brand))];
        subwalletnum[string(abi.encodePacked(_id,"@",_brand,"$",Strings.toString(m)))]=string(abi.encodePacked(_id,"@",_brand,"$",_walletname));
        ispremium[wa]=false;
        joiningnum[usercount]=string(abi.encodePacked(_id,"@",_brand));
         usercount++;
    }
    function updateaddress(string memory _id,string memory _brand,string memory _walletname,string memory _add) external {
        //bytes memory b=bytes(_address);
        _id=validate(_id);
        _brand=validate(_brand);
         require(keccak256(abi.encodePacked("ucpi"))==keccak256(abi.encodePacked(_brand)),"no custom brands allowed");
        _walletname=validate(_walletname);
   require(walletowner[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]==msg.sender);
        wallet[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=_add;
    }
    function addwallet(string memory _id,string memory _brand,string memory _walletname,string memory _add,address _ethadd) external{
     _id=validate(_id);
        _brand=validate(_brand);
        _walletname=validate(_walletname);
         require(keccak256(abi.encodePacked("ucpi"))==keccak256(abi.encodePacked(_brand)),"no custom brands allowed");
     require(idowner[string(abi.encodePacked(_id,"@",_brand))]==msg.sender);
     require( idexist[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]==false,"wallet name exists");
     wallet[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=_add;
     walletowner[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=_ethadd;
       walletsubwallet[string(abi.encodePacked(_id,"@",_brand))]=string(abi.encodePacked(walletsubwallet[string(abi.encodePacked(_id,"@",_brand))],",",_id,"@",_brand,"$",_walletname));
     numofwallet[string(abi.encodePacked(_id,"@",_brand))]+=1;
      uint m=numofwallet[string(abi.encodePacked(_id,"@",_brand))];
        subwalletnum[string(abi.encodePacked(_id,"@",_brand,"$",Strings.toString(m)))]=string(abi.encodePacked(_id,"@",_brand,"$",_walletname));

     
    }
    function changeprimary(string memory _id,string memory _brand,string memory _walletname,address _ethadd) external{
         _id=validate(_id);
        _brand=validate(_brand);
        _walletname=validate(_walletname);
          require(keccak256(abi.encodePacked("ucpi"))==keccak256(abi.encodePacked(_brand)),"no custom brands allowed");
         require(idowner[string(abi.encodePacked(_id,"@",_brand))]==msg.sender);
         require( idexist[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=true,"wallet name exists");
          primarywallet[string(abi.encodePacked(_id,"@",_brand))]=_walletname;
          idowner[string(abi.encodePacked(_id,"@",_brand))]=_ethadd;
    }
    function validate(string memory s) public pure returns(string memory){
     bytes memory bStr = bytes(s);
        bytes memory bLower = new bytes(bStr.length);
        for (uint i = 0; i < bStr.length; i++) {
            // Uppercase character...
            if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
                // So we add 32 to make it lowercase
                bLower[i] = bytes1(uint8(bStr[i]) + 32);
            }
            else if((uint8(bStr[i]) >= 33) && (uint8(bStr[i]) <= 47)){
              revert("special character not allowed");
            } 
            else if((uint8(bStr[i]) >= 58) && (uint8(bStr[i]) <= 64)){
              revert("special character not allowed");
            } 
             else if((uint8(bStr[i]) >= 91) && (uint8(bStr[i]) <= 96)){
              revert("special character not allowed");
            } 
             else if((uint8(bStr[i]) >= 123) && (uint8(bStr[i]) <= 127)){
              revert("special character not allowed");
            } 
            
            else {
                bLower[i] = bStr[i];
            }
        }
        return string(bLower);
    }
 function recoverSigner(bytes memory _signature)
        public
        pure
        returns (address)
    {
         // bytes memory prefix = "\x19Ethereum Signed Message:\n32";
  //       (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
  // bytes32 prefixedHashMessage = keccak256(abi.encodePacked(prefix, _ethSignedMessageHash));
           bytes32 wlcmhash=0x894717e02bc1017f7347665a198b3cb74671478407a02a65b750d7e88f8f8570;
          bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
        bytes32 prefixedHashMessage = keccak256(abi.encodePacked(prefix,wlcmhash));
         
        return ecrecover(prefixedHashMessage, v, r, s);
    }

    function VerifyMessage(bytes32 _hashedMessage, uint8 _v, bytes32 _r, bytes32 _s) public pure returns (address) {
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 prefixedHashMessage = keccak256(abi.encodePacked(prefix, _hashedMessage));
        address signer = ecrecover(prefixedHashMessage, _v, _r, _s);
        return signer;
    }
   function splitSignature(bytes memory sig)
        public
        pure
        returns ( bytes32 r,bytes32 s,uint8 v)   
    {
        require(sig.length == 65, "invalid signature length");
            
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }

//     function get(string memory key) 
//     public 
//     view 
//     returns (bytes32) {
//         return bytes32(abi.encodePacked(key));
// }
function upgradeplan() external payable{
  require(msg.value== 151000000000000000000,"please send 2 ");
  payable(ucpimultisign).transfer(150000000000000000000);
  ispremium[msg.sender]=true;
}
function bal() public view returns(uint){
  return address(this).balance;
}
function changeidprice(string memory _id,uint256 amount) external {
require(msg.sender==walletowner[_id],"you are not authorized owner");
idprice[_id]=amount;
}
function buyid(string memory _id,string memory add,string memory _walletname,uint amnt ) external payable{
  require(msg.value==idprice[_id],"please send amount set by owner");
  string memory _brand="ucpi";
     require(idexist[string(abi.encodePacked(_id,"@","ucpi"))]==false,"id not present");
      //require(&&idexist[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=false,"wall")
         payable(ucpimultisign).transfer(idprice[_id]/10);
          payable( idowner[string(abi.encodePacked(_id,"@",_brand))]).transfer(8*(idprice[_id]/10));
        mainid[string(abi.encodePacked(_id,"@",_brand))]="";
        walletsubwallet[string(abi.encodePacked(_id,"@",_brand))]="";
        primarywallet[string(abi.encodePacked(_id,"@",_brand))]=_walletname;
        idexist[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=true;
        idowner[string(abi.encodePacked(_id,"@",_brand))]=msg.sender;
        mainid[string(abi.encodePacked(_id,"@",_brand))]=add;
        walletowner[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]=msg.sender;
        idprice[string(abi.encodePacked(_id,"@",_brand))]=amnt;
        walletownercount[msg.sender]+=1;
        ispremium[msg.sender]=false;
        uint x=numofwallet[string(abi.encodePacked(_id,"@",_brand))];
         for(uint i=0; i<x; i++){
       
        string memory swa=subwalletnum[string(abi.encodePacked(_id,"@",_brand,"$",Strings.toString(i)))];
        walletowner[swa]=msg.sender;
     wallet[string(abi.encodePacked(_id,"@",_brand,"$",_walletname))]="";
         }  
     numofwallet[string(abi.encodePacked(_id,"@",_brand))]=0;
     resellcount++;
}

}
