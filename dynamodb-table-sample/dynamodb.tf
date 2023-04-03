##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}


##################################################################################
# RESOURCES
##################################################################################

# NOSQL DATABASE # 
resource "aws_dynamodb_table" "tf_notes_table" {    
   name = "tf-notes-table" 
   billing_mode = "PROVISIONED" 
   read_capacity = "1" // RCU 
   write_capacity = "1" // WCU
   hash_key = "noteId"

   attribute { 
      name = "noteId" 
      type = "S" 
   } 
    
   ttl { 
     enabled = true
     attribute_name = "expiryPeriod"  
   }

   point_in_time_recovery { enabled = true } 
   server_side_encryption { enabled = false } 
}