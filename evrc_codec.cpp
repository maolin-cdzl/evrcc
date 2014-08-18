#include <iostream>
#include <fstream>
#include <string>
#include <vector>

#include <time.h>
#ifdef WIN32
#   include <windows.h>
#else
#   include <sys/time.h>
#endif
#ifdef WIN32
static int gettimeofday(struct timeval *tp, void *tzp)
{
    time_t clock;
    struct tm tm;
    SYSTEMTIME wtm;
    GetLocalTime(&wtm);
    tm.tm_year     = wtm.wYear - 1900;
    tm.tm_mon     = wtm.wMonth - 1;
    tm.tm_mday     = wtm.wDay;
    tm.tm_hour     = wtm.wHour;
    tm.tm_min     = wtm.wMinute;
    tm.tm_sec     = wtm.wSecond;
    tm. tm_isdst    = -1;
    clock = mktime(&tm);
    tp->tv_sec = clock;
    tp->tv_usec = wtm.wMilliseconds * 1000;
    return (0);
}
#endif

#include "evrcc.h"

using namespace std;

int encodefile(const std::string& infile,const std::string& outfile) {
	ifstream ifs;
	ifs.open(infile.c_str(),ios::in | ios::binary);

	if( ifs.fail() ) {
		cout << "can not open file " << infile << endl;
		return -1;
	}

	ofstream ofs;
	ofs.open(outfile.c_str(),ios::out | ios::binary);
	if( ofs.fail() ) {
		cout << "can not create file " << outfile << endl;
		return -1;
	}
	
	unsigned char* evrc = new unsigned char[1024*100];

	std::vector<unsigned char> pcm;
	typedef std::istreambuf_iterator<char> FsIt;
	std::copy(FsIt(ifs),FsIt(),std::back_inserter(pcm));

	size_t nFrame = pcm.size()/320;

	void* ct = evrc_encoder_init(4,4,1);
	struct timeval start;
	gettimeofday(&start,NULL);
	int r = evrc_encoder_encode_to_stream(ct,(short*)&(pcm[0]),pcm.size()/sizeof(short),evrc,1024*100);
	struct timeval end;
	gettimeofday(&end,NULL);
	long msUse = ( (end.tv_sec - start.tv_sec) * 1000 + (end.tv_usec - start.tv_usec)/1000 );
	cout << "encode " << nFrame << " frames for " << nFrame * 20 << "ms, use " << msUse << "ms" <<
	   " average " << (float)msUse/nFrame << "ms/frame" <<	endl;

	if( r > 0 ) {
		ofs.write((char*)evrc,r);
	} else {
		cout << "no data output at frame " << nFrame << endl;
	}
	evrc_encoder_uninit(ct);
	ifs.close();
	ofs.close();
	return 0;
}

int decodefile(const std::string& infile,const std::string& outfile) {
	ifstream ifs;
	ifs.open(infile.c_str(),ios::in | ios::binary);

	if( ifs.fail() ) {
		cout << "can not open file " << infile << endl;
		return -1;
	}

	ofstream ofs;
	ofs.open(outfile.c_str(),ios::out | ios::binary);
	if( ofs.fail() ) {
		cout << "can not create file " << outfile << endl;
		return -1;
	}
	
	std::vector<unsigned char> bits;
	typedef std::istreambuf_iterator<char> FsIt;
	std::copy(FsIt(ifs),FsIt(),std::back_inserter(bits));
	if( !bits.empty() ) {
		void* ct = evrc_decoder_init();
		const int words = evrc_decoder_stream_max_sample(&(bits[0]),bits.size());
		short* pcm_buf = new short[words];

		int bytes = evrc_decoder_decode_from_stream(ct,&(bits[0]),bits.size(),pcm_buf,words);
		if( bytes > 0 ) {
			cout << "decode " << bytes / 320 << " frames" << endl;
			ofs.write((char*)pcm_buf,bytes);
		}
		delete [] pcm_buf;
		evrc_decoder_uninit(ct);
	}
	
	ifs.close();
	ofs.close();
	return 0;
}


int main(int argc,char* argv[]) {
	/*
     *cout << "Usage: " << argv[0] << " e speechfile bitstreamfile" << endl;
	 *cout << "or   : " << argv[0] << " d bitstreamfile speechfile" << endl;
	 *encodefile("/sdcard/pcm.raw","/sdcard/evrc.raw");
	 *return 0;
	 */

	if( argc < 4 ) {
		cout << "Usage: " << argv[0] << " e speechfile bitstreamfile" << endl;
				cout << "or   : " << argv[0] << " d bitstreamfile speechfile" << endl;

		return 0;
	}

	if( 'd' == argv[1][0] ) {
		decodefile(argv[2],argv[3]);
	} else if( 'e' == argv[1][0] ) {
		encodefile(argv[2],argv[3]);
	} else {
		std::cout << "unknown opt" << std::endl;
	}
	return 0;
}

