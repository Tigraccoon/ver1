package com.ver1.board.model.board.dao;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.ver1.board.model.board.dto.BoardDTO;

@Repository
public class FileDAOImpl implements FileDAO {

	@Inject 
	SqlSession sqlSession;
	
	@Override
	public void InsertFile(BoardDTO dto) {

		sqlSession.insert("file.insert", dto);
	}

	@Override
	public List<BoardDTO> FileList(int b_num) {

		return sqlSession.selectList("file.list", b_num);
	}

	@Override
	public BoardDTO FileInfo(int f_num) {

		return sqlSession.selectOne("file.fileinfo", f_num);
	}

	@Override
	public void DelFile(int f_num) {

		sqlSession.delete("file.delfile", f_num);
		
	}

}
