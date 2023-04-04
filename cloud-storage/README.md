cat <<EOF | sudo tee .github/README.md
# step export
# 1. prepare vm instance
# 2. create snapshot from vm instance
# 3. create image from snapshot
# 4. export image as VMDK/VHD to bucket (google cloud storage)
# 5. specify location and grant access public for allUsers 
# 6. download to local
# 
# step import 
# 1. create bucket (google cloud storage)
# 2. import VMDK/VHD from local to bucket
# 3. create image from bucket
# 4. create snapshot from image
# 5. create instance from snapshot
#
