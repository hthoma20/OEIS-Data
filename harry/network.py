import json
#let A be the set of sequences and
#let U be the set of users
#define the relation, 'contributes' on UxA
#as u in U contributes to a in A
#	iff u's name appears on the OEIS page for a
#
#define the relation 'posts with' on UxU as
# u1 posts with u2 iff u1 contributes to a and u2 contributes to a
#	for some a in A
#
#define a contributes map, c, as a dictionary with keys in A, and values
#being lists of users in U where a -> [u1,u2,...] such that
#	c[a] contains u iff u contributes to a
#
#define a postswith map, p, as a dictionary with keys in U, and values
#being lists of users in U where u -> [u1,u2,...] such that
#	c[u] contains user s iff u contributes posts with s


#take in a contributes map
#return the corresponding postswith map
def contributes_to_postswith(contributes):
	postswith= {}
	
	#go thru each sequence
	for sequence in contributes:
		#each user of this sequence will be a key
		for user_key in contributes[sequence]:
			if user_key not in postswith:
				postswith[user_key]= []
			
			#look for users that this user postswith
			for user_val in contributes[sequence]:
				
				#if this user is not already in the key's list, add them
				if user_val not in postswith[user_key]:
					postswith[user_key].append(user_val)

	return postswith
	
#read a file that contains a contributes map in json formate
#return the contributes map
def json_to_contributes(path):
	with open(path) as f:
		map = json.load(f)
	return map
	
#get the postswith map from the nth thousand sequences
def get_postswith(n):
	num= (n-1)*1000+1
	path= 'maps/map'+str(num)+'.json'
	return contributes_to_postswith(json_to_contributes(path))
	