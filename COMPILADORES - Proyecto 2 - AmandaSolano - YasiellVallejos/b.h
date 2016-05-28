
int primo(int n){ 
int i, m; 
for(i=2;i<n;i++) { 
	m=n%i; 
	if(m==0) 
		return 1; 
} 
return 0; 
} 

