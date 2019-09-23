package com.ver1.board.model.board.dao;

import java.util.List;

import com.ver1.board.model.board.dto.BoardDTO;

public interface FileDAO {
	public void InsertFile(BoardDTO dto);
	public List<BoardDTO> FileList(int b_num);
	public BoardDTO FileInfo(int f_num);
	public void DelFile(int f_num);
	
}
