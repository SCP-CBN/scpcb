namespace String {

	shared int findFirstChar(string str,string delim) { for(int i=0; i<str.length(); i++) { if(str[i]==delim) { return i; } } return -1; }
	shared string substr(string str, int start, int end) { string phrase=""; for(int i=start; i<=end; i++) { phrase+=str[i]; } return phrase; }
	shared array<string> explode(string str,string delim) {
		int f=findFirstChar(str,delim);
		if(f<0) { return {str};}
		array<string> words;
		string phrase=str;
		while(f>-1) {
			string w=phrase.substr(0,f);
			words.insertLast(w);
			phrase=substr(phrase,f+1,phrase.length());
			f=findFirstChar(phrase,delim);
			if(f<0) { words.insertLast(phrase); break; }
		}
		return words;
	}

	shared string implode(array<string> words, string delim) {
		return "todo";
	}

}