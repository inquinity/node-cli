#! /bin/bash

# Set the name of our executable tool
executable_file_name=node_cli

# Configuration file
sea_config=sea-config.json

# sea-config blob file; this is reference in the config file
sea_blob=sea-prep.blob

# Generate the "blob" to be injected the node executable; this uses the a json configuration file
# https://nodejs.org/api/single-executable-applications.html#generating-single-executable-preparation-blobs
node --experimental-sea-config ${sea_config}

# Create a copy of the node executable and name it as your cli name
rm -f ${executable_file_name}
cp $(command -v node) ${executable_file_name}

# Remove the existing code signature
codesign --remove-signature ${executable_file_name}

# Run ths node postject script
echo -n "Please enable AdminAccess for sudo. Press Enter to continue"
read
sudo npx postject ${executable_file_name} NODE_SEA_BLOB ${sea_blob} --sentinel-fuse NODE_SEA_FUSE_fce680ab2cc467b6e072b8b5df1996b2 --macho-segment-name NODE_SEA
echo sudo completed. You can disable AdminAccess

# sign the executable
codesign --sign - ${executable_file_name}
