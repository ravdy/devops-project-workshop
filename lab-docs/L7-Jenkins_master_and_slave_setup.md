# Jenkins master and Slave setup
   Follow the below setups to add a new slave node to the jenkins 
1. Goto Manage Jenkins --> Manage nodes and clouds --> New node --> Permanent Agent    
1. Provide below info to add the node   
   Number of executors: `3`   
   Remote root directory: `/home/ec2-user/jenkins`  
   Labels: `maven`  
   Usage: `Use this node as much as possible`  
   Launch method: `Launch agents via SSH`  
        Host: `<Private_IP_of_Slave>`  
        Credentials: `<Jenkins_Slave_Credentials>`     
        Host Key Verification Strategy: `Non verifying Verification Strategy`     
   Availability: `Keep this agent online as much as possible`