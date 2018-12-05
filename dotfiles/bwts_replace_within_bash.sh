function bwts_replace() {
	
   pattern="$1"
   replace="$1" 
   folder="$3"
   
   if [ -z {1} || -z ${3} ]; then
     info "USAGE: bwts_replace $pattern $replace $destination"
     warn '$pattern $destination canot be empty'
     exit
   fi

   if [ ! -s $destination ]; then
     error "Destination file does not exist!"
     exit
   fi
 
   sed -ie s%"$pattern"%"$replace"% ${destination}
}