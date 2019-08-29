package com.ver1.board.model.board.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.ver1.board.model.board.dto.BoardDTO;

@Repository
public class BoardDAOImpl implements BoardDAO {
	
	@Inject
	SqlSession sqlSession;
	
	@Override
	public List<BoardDTO> b_list(String option, String keyword, int begin, int end) {
		
		Map<String, Object> map = new HashMap<>();
		map.put("begin", begin);
		map.put("end", end);
		map.put("option", option);
		map.put("keyword", keyword);
		
		return sqlSession.selectList("board.b_list", map);
	}

	@Override
	public BoardDTO b_view(int b_num, HttpSession session) {
		long update_time = 0;
		if(session.getAttribute("update_time_" + b_num) != null) {
			update_time = (long)session.getAttribute("update_time_" + b_num); 
		}
		
		long current_time = System.currentTimeMillis();
		if(current_time - update_time >= 5 * 1000) {
			sqlSession.update("board.b_upcount", b_num);
			session.setAttribute("update_time_" + b_num, current_time);
		}
		
		return sqlSession.selectOne("board.b_view", b_num);
	}

	@Override
	@Transactional
	public int b_insert(BoardDTO dto) {
		
		sqlSession.insert("board.b_insert", dto);
		
		return sqlSession.selectOne("board.getcurrval");
	}

	@Override
	public void b_update(BoardDTO dto) {
		
		sqlSession.update("board.b_update", dto);
	}

	@Override
	public void b_delete(int b_num) {
		
		sqlSession.delete("board.b_delete", b_num);
	}

	@Override
	public void b_upcount(int b_num) {
		
		sqlSession.update("board.b_upcount", b_num);
	}

	@Override
	public int b_count(String option, String keyword) {
		
		Map<String, Object> map = new HashMap<>();
		map.put("option", option);
		map.put("keyword", keyword);
		
		return sqlSession.selectOne("board.b_count", map);
	}

	@Override
	public int c_count(int b_num) {
		
		return sqlSession.selectOne("board.c_count", b_num);
	}

}
