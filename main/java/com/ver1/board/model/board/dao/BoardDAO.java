package com.ver1.board.model.board.dao;

import java.util.List;

import javax.servlet.http.HttpSession;

import com.ver1.board.model.board.dto.BoardDTO;

public interface BoardDAO {
	
	public List<BoardDTO> b_list(String option, String keyword, int begin, int end);	//리스트
	public BoardDTO b_view(int b_num, HttpSession session);									//글보기
	public int b_insert(BoardDTO dto);									//글쓰기
	public void b_update(BoardDTO dto);									//글수정
	public void b_delete(int b_num, int b_mnum);									//글삭제
	public void b_upcount(int b_num);									//조회수 증가
	public int b_count(String option, String keyword);				//글 갯수
	public int c_count(int b_num);
	public boolean pwdcheck(BoardDTO dto);
	public BoardDTO b_getupperinfo(int b_num);
	public int b_reinsert(BoardDTO dto);
	
}
