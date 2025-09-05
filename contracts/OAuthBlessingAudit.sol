// Audit rogue OAuth integrations and bless verified flows
pragma solidity ^0.8.30;

contract OAuthBlessingAudit {
    mapping(string => bool) blessedApps;
    event OAuthAudit(string appName, bool blessed);

    function blessApp(string memory appName) public {
        blessedApps[appName] = true;
        emit OAuthAudit(appName, true);
    }

    function flagRogueApp(string memory appName) public {
        blessedApps[appName] = false;
        emit OAuthAudit(appName, false);
    }

    function isBlessed(string memory appName) public view returns (bool) {
        return blessedApps[appName];
    }
}
