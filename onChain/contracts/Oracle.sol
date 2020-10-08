pragma solidity ^0.4.22;

contract Oracle	{
	Request[] requests;
	uint currentId = 0;
	uint minResponse = 3;
	uint totalOracleCount = 5;

	struct Request {
		uint id;
		string urlToQuerry;
		string attributeToFetch;
		string agreedValue;
		mapping(uint => string) ans;
		mapping(address => uint) quorum;
	}

	event NewRequest (
		uint id,
		string urlToQuerry,
		string attributeToFetch
	);

	event UpdatedRequest (
		uint id,
		string urlToQuerry,
		string attributeToFetch,
		string agreedValue
	);

	function createRequest ( string memory _urlToQuerry, string memory _attributeToFetch) public {
		uint leng = requests.push(Request(currentId, _urlToQuerry, _attributeToFetch, ""));
		Request storage r = requests[leng-1];

		r.quorum[address(0x6c2339b46F41a06f09CA0051ddAD54D1e582bA77)] = 1;
	    r.quorum[address(0xb5346CF224c02186606e5f89EACC21eC25398077)] = 1;
	    r.quorum[address(0x1E348e1873765043aAC6C39174C4d8818256E3df)] = 1;
	    r.quorum[address(0x7EfB568747439E8d9204f645Cd39f7b4C42f2E97)] = 1;
	    r.quorum[address(0xeff0891bB026690572D53f34ccb1723B5e80a2DE)] = 1;

	    emit NewRequest ( currentId, _urlToQuerry, _attributeToFetch);

	    currentId++;

	}

	function updateRequest (uint _id, string memory _valueRetrieved) public {
		Request storage curRequest = requests[_id];

		if(curRequest.quorum[address(msg.sender)] == 1){
			curRequest.quorum[msg.sender] = 3;

			uint tmpI = 0;
			bool found = false;

			while(!found) {
				if(bytes(curRequest.ans[tmpI]).length == 0){
					found = true;
					curRequest.ans[tmpI] = _valueRetrieved;
				}
				tmpI++;
			}
			uint currentQuorum = 0;

			for(uint i = 0; i < totalOracleCount; i++){
		        bytes memory a = bytes(curRequest.ans[i]);
		        bytes memory b = bytes(_valueRetrieved);

		        if(keccak256(a) == keccak256(b)){
		          currentQuorum++;
		          if(currentQuorum >= minResponse){
		            curRequest.agreedValue = _valueRetrieved;
		            emit UpdatedRequest (
		              curRequest.id,
		              curRequest.urlToQuerry,
		              curRequest.attributeToFetch,
		              curRequest.agreedValue
		            );
		          }
		        }
	      	}
		}
	}
}