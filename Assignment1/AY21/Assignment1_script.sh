#Create Assignment 1 directory in home directory
mkdir Assignment1; cd ~/Assignment1

#Copy AY21 directory into own directory
cp -r /localdisk/data/BPSM/AY21 .

#Unzip files
cd ~/Assignment1/AY21/fastq; for gzip in *.gz; do gzip -d $gzip; done

#Run fastqc on all .fq files
fastqc *.fq

#Create directory for fastqc results
mkdir fastqc_results

#Move fastqc results into new directory
grep -lir 'fastqc' * |xargs  mv -t fastqc_results

#Unzip fastqc files  
cd ~/Assignment1/AY21/fastq/fastqc_results; for filename in *.zip; do unzip $filename; done

#Concatenate summary files into one big one
cat */summary.txt > ~/Assignment1/AY21/fastq/fastqc_results/fastqc_summaries.txt 

#Summary of FastQC
grep -c PASS fastqc_summaries.txt
#777
grep -c WARN fastqc_summaries.txt
#86
grep -c FAIL fastqc_summaries.txt
#37

#Per sequence quality score
awk 'NR % 10 == 2' fastqc_summaries.txt > sequence_quality.txt
wc -l sequence_quality.txt
grep -c PASS sequence_quality.txt


##Question 3
#Move to Tcongo_genome directory
cd ~/Assignment1/AY21/Tcongo_genome; for gzip in *.gz; do gzip -d $gzip; done

#How many sequences are there?
grep -c ">" TriTrypDB-46_TcongolenseIL3000_2019_Genome.fasta
#Answer: 375

#DNA or protein? Create DNA_or_protein.awk file
cat TriTrypDB-46_TcongolenseIL3000_2019_Genome.fasta| awk '{
# Is this line a fasta header
if(substr($1,1,1)==">")
 {
print "this is a header line: " $0; 
hline=FNR ;
 }
# Identify the first line of the sequence
# ...and then the first character of that line
if(FNR==hline+1)
 {
print "First line is:" $0;
first_seq_character=substr($0,1,1)
print "First character is: " first_seq_character
print first_seq_character > "first_seq_character.txt" 
 }
}'

