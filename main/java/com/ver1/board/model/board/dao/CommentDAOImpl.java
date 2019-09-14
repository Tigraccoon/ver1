package com.ver1.board.model.board.dao;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.ver1.board.model.board.dto.CommentDTO;

@Repository
public class CommentDAOImpl implements CommentDAO {

	@Inject
	SqlSession sqlSession;
	
	@Override
	public List<CommentDTO> c_list(int b_num) {
		
		return sqlSession.selectList("comment.c_list", b_num);
	}

	@Override
	public void c_insert(CommentDTO dto) {
		sqlSession.insert("comment.c_insert", dto);
	}

	@Override
	public void c_update(CommentDTO dto) {
		
		sqlSession.update("comment.c_update", dto);
	}

	@Override
	public void c_delete(int c_num) {
		
		sqlSession.delete("comment.c_delete", c_num);
	}

}
