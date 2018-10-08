pragma solidity ^0.4.24;

contract Ownable {
  address private _owner;

  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  constructor() public {
    _owner = msg.sender;
  }

  function owner() public view returns (address) {
    return _owner;
  }

  modifier onlyOwner() {
    require(isOwner(), "Only owner.");
    _;
  }

  function isOwner() public view returns (bool) {
    return msg.sender == _owner;
  }

  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0));
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

contract Viewable is Ownable {
  address private _viewer;

  function isViewer() public view returns (bool) {
    return msg.sender == _viewer;
  }

  function setViewer(address newViewer) public onlyOwner {
    _viewer = newViewer;
  }
}

contract NsCertificate is Viewable {
  mapping(uint8 => address[]) private _classes;
  mapping(address => string) private _students;

  function studentsOfClass(uint8 id) public view returns(address[]) {
    return _classes[id];
  }

  function nameOf(address student) public view returns(string) {
    require(msg.sender == student || isViewer() || isOwner(), "Only self or viewer or owner");

    return _students[student];
  }

  function updateClass(uint8 classId, address[] students) public onlyOwner {
    _classes[classId] = students;
  }

  function updateStudent(address addressOfStudent, string name) public onlyOwner {
    _students[addressOfStudent] = name;
  }
}
