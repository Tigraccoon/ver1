package com.ver1.board.model.board;

public class Pager {
	public static final int PAGE_SCALE=10; //페이지당 게시물수
	public static final int BLOCK_SCALE=10;//화면당 페이지수
	
	private int curPage; //현재 페이지
	private int prevPage; //이전 페이지
	private int nextPage; //다음 페이지
	private int totPage; //전체 페이지 갯수
	private int totBlock; //전체 페이지블록 갯수
	private int curBlock; //현재 블록
	private int prevBlock; //이전 블록
	private int nextBlock; //다음 블록
	private int pageBegin; // #{start} 변수에 전달될 값
	private int pageEnd; // #{end} 변수에 전달될 값
	private int blockBegin; //블록의 시작페이지 번호
	private int blockEnd; //블록의 끝페이지 번호
	
	//getter,setter(상수2개는 제외)우선만들고 수정함, 생성자
	// Pager(레코드갯수, 출력할페이지번호)
	public Pager(int count, int curPage) {
		curBlock = 1; //현재블록 번호
		this.curPage = curPage; //현재 페이지 번호
		setTotPage(count); //전체 페이지 갯수 계산
		setPageRange(); // #{start}, #{end} 값 계산
		setTotBlock(); // 전체 블록 갯수 계산
		setBlockRange(); //블록의 시작,끝 번호 계산
	}
	public void setTotPage(int count) {
		//전체 페이지 갯수 계산
		//Math.ceil() 올림		
		//전체 페이지 = (정수형반환)올림((게시물수*1.0) / 10)
		//1.0곱하는 이유는 올림 처리를 해야하는데 소숫점 이하의 수가 있어야 정상적으로 올림이 되기 때문에
		totPage = (int)Math.ceil(count*1.0 / PAGE_SCALE);
	}
	public void setPageRange() {
		//페이지 범위 계산
		// where rn between #{start} and #{end}에 입력될 값		
		// 시작번호=(현재페이지-1)x페이지당 게시물수 + 1
		// cp-1을 하는 이유는 실제 페이지에 보여지는 개시물의 번호가 페이지 단위 번호보다 1 작기 떄문에
		// 컴퓨터와 사람의 계산식이 달라서 컴퓨터의 계산식에 맞추기 위해
		// 끝번호=시작번호 + 페이지당 게시물수 - 1		
		pageBegin = (curPage-1) * PAGE_SCALE + 1;
		pageEnd = pageBegin + PAGE_SCALE - 1;
	}
	//블록의 갯수 계산
	public void setTotBlock() {
		totBlock = (int)Math.ceil(totPage*1.0 / BLOCK_SCALE);
	}
	public void setBlockRange() {
		//원하는 페이지가 몇번째 블록에 속하는지 계산
		curBlock=(curPage-1)/BLOCK_SCALE + 1;
		//블록의 시작페이지,끝페이지 번호 계산
		blockBegin=(curBlock-1)*BLOCK_SCALE+1;
		blockEnd=blockBegin+BLOCK_SCALE-1;
		//마지막 블록 번호가 범위를 초과하지 않도록 처리
		if(blockEnd > totPage) {
			blockEnd = totPage;
		}                                                                                                                                             
		//[이전][다음]을 눌렀을 때 이동할 페이지 번호
		prevPage=(curBlock==1) ? 1 : (curBlock-1)*BLOCK_SCALE;
		nextPage=curBlock>totBlock ? (curBlock*BLOCK_SCALE)
				: (curBlock*BLOCK_SCALE)+1;
		//마지막 페이지가 범위를 초과하지 않도록 처리
		if(nextPage >= totPage) {
			nextPage=totPage;
		}
	}
	public int getCurPage() {
		return curPage;
	}
	public void setCurPage(int curPage) {
		this.curPage = curPage;
	}
	public int getPrevPage() {
		return prevPage;
	}
	public void setPrevPage(int prevPage) {
		this.prevPage = prevPage;
	}
	public int getNextPage() {
		return nextPage;
	}
	public void setNextPage(int nextPage) {
		this.nextPage = nextPage;
	}
	public int getTotPage() {
		return totPage;
	}
	public int getTotBlock() {
		return totBlock;
	}
	public void setTotBlock(int totBlock) {
		this.totBlock = totBlock;
	}
	public int getCurBlock() {
		return curBlock;
	}
	public void setCurBlock(int curBlock) {
		this.curBlock = curBlock;
	}
	public int getPrevBlock() {
		return prevBlock;
	}
	public void setPrevBlock(int prevBlock) {
		this.prevBlock = prevBlock;
	}
	public int getNextBlock() {
		return nextBlock;
	}
	public void setNextBlock(int nextBlock) {
		this.nextBlock = nextBlock;
	}
	public int getPageBegin() {
		return pageBegin;
	}
	public void setPageBegin(int pageBegin) {
		this.pageBegin = pageBegin;
	}
	public int getPageEnd() {
		return pageEnd;
	}
	public void setPageEnd(int pageEnd) {
		this.pageEnd = pageEnd;
	}
	public int getBlockBegin() {
		return blockBegin;
	}
	public void setBlockBegin(int blockBegin) {
		this.blockBegin = blockBegin;
	}
	public int getBlockEnd() {
		return blockEnd;
	}
	public void setBlockEnd(int blockEnd) {
		this.blockEnd = blockEnd;
	}
	
}

