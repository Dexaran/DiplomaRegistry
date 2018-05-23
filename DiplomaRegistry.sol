pragma solidity ^0.4.18;

contract DiplomaRegistry {

    address public owner = msg.sender;
    event DiplomaRegistered(string indexed id, string indexed name, uint256 indexed date, string profile);
    
    struct diploma
    {
        string  id;
        string  student_name;
        string  student_profile;
        uint256 date; //in UNIX seconds
    }
    
    mapping (bytes32 => diploma) diplomas;
    mapping (bytes32 => diploma) diplomas_by_names;
    
    function register_diploma(string _id, string _student_name, string _student_profile, uint256 _date) only_owner
    {
        bytes32 _signature = sha3(_id);
        diplomas[_signature].id              = _id;
        diplomas[_signature].student_name    = _student_name;
        diplomas[_signature].student_profile = _student_profile;
        diplomas[_signature].date            = _date;
        
        bytes32 _name_signature = sha3(_student_name);
        diplomas_by_names[_name_signature].id              = _id;
        diplomas_by_names[_name_signature].student_name    = _student_name;
        diplomas_by_names[_name_signature].student_profile = _student_profile;
        diplomas_by_names[_name_signature].date            = _date;
        
        emit DiplomaRegistered(_id, _student_name, _date, _student_profile);
    }
    
    function get_diploma_by_id(string _id) constant returns (string, string, string, uint256)
    {
        bytes32 _signature = sha3(_id);
        return(
            diplomas[_signature].id,
            diplomas[_signature].student_name,
            diplomas[_signature].student_profile,
            diplomas[_signature].date
            );
    }
    
    function get_diploma_by_name(string _student_name) constant returns (string, string, string, uint256)
    {
        bytes32 _name_signature = sha3(_student_name);
        return(
            diplomas_by_names[_name_signature].id,
            diplomas_by_names[_name_signature].student_name,
            diplomas_by_names[_name_signature].student_profile,
            diplomas_by_names[_name_signature].date
            );
    }
    
    modifier only_owner
    {
        assert(msg.sender == owner);
        _;
    }
}
