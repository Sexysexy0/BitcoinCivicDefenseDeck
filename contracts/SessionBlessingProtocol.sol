// Bless and monitor browser sessions for hijack attempts
pragma solidity ^0.8.30;

contract SessionBlessingProtocol {
    mapping(string => bool) blessedSessions;
    event SessionAudit(string sessionId, bool blessed);

    function blessSession(string memory sessionId) public {
        blessedSessions[sessionId] = true;
        emit SessionAudit(sessionId, true);
    }

    function flagHijack(string memory sessionId) public {
        blessedSessions[sessionId] = false;
        emit SessionAudit(sessionId, false);
    }

    function isBlessed(string memory sessionId) public view returns (bool) {
        return blessedSessions[sessionId];
    }
}
