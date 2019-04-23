from requests import get
from contextlib import closing
from bs4 import BeautifulSoup
import json

#get buitiful soup parsable html stuff from the given url
def get_soup(url):
	#send the request
	with closing(get(url, stream=True)) as resp:
		if resp.status_code == 200:
			html= resp.content
		else:
			return None
	
	soup = BeautifulSoup(html, 'html.parser')
	return soup

def user_href(href):
	return href.startswith('/wiki/User:')
	
#given a sequence name (i.e. 'A000055'), return a list of all associated users
def sequence_users(seqName):
	#get the html
	html = get_soup('https://oeis.org/' + seqName)
	
	users= []
	for a_tag in html.findAll('a', href= user_href):
		#get the substring of the actual user the prefix is 11 chars
		user= a_tag['href'][11:]
		if user not in users:
			users.append(user)
	
	return users
	
#return a map from sequence name to a list of users in that sequence
#do this for the provided range
def sequence_users_map(start, end):
	map= {}
	template= 'A000000'
	for i in range(start, end):
		seq_name= str(i)
		#the template length is 7
		seq_name= template[:7-len(seq_name)]+seq_name
		
		map[seq_name]= sequence_users(seq_name)
		print(seq_name)
	
	return map
	
if __name__ == "__main__":
	#do 1000 at a time
	start= 154
	for i in range((start-1)*1000+1, 322000, 1000):
		map= sequence_users_map(i, i+1000)
		
		file_name= 'maps/map'+str(i)+'.json'
		with open(file_name, 'w') as json_file:
			json.dump(map, json_file)
