package com.ver1.board.model.board.dao;

import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.ResultContext;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.SqlSession;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
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
	@Transactional
	public void b_delete(int b_num, int b_mnum) {
		
		sqlSession.delete("board.b_delete", b_num);
		
		Map<String, Object> map = new HashMap<>();
		map.put("b_num", b_num);
		map.put("b_mnum", b_mnum);
		
		List<String> list = sqlSession.selectList("board.showcheck", map);
		
		boolean result = false;
		
		if(list.indexOf("Y") == -1) result = true; 

		if(result) {
			sqlSession.delete("b_deleteall", map);
		}
		
		
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

	@Override
	public boolean pwdcheck(BoardDTO dto) {
		
		int result = sqlSession.selectOne("board.pwdcheck", dto);

		if(result == 1) {
			return true;
		} else {
			return false;
		}
		
	}

	@Override
	public BoardDTO b_getupperinfo(int b_num) {
		
		BoardDTO dto = sqlSession.selectOne("board.upperinfo", b_num);
		
		return dto;
	}

	@Override
	@Transactional
	public int b_reinsert(BoardDTO dto) {
		
		sqlSession.insert("board.b_reinsert", dto);
		
		return sqlSession.selectOne("board.getcurrval");
	}

	@Override
	public void b_updateall(BoardDTO dto) {
		sqlSession.update("board.b_updateall", dto);
	}

	@Override
	@Transactional
	public void excel(HttpServletResponse response) {
		// 메모리에 100개의 행을 유지합니다. 행의 수가 넘으면 디스크에 적습니다.
		SXSSFWorkbook wb = new SXSSFWorkbook(100);
		Sheet sheet = wb.createSheet();
		Map<String, String> map = new HashMap<>();
		
		map.put("keyword", "%");
		map.put("option", "%");
		
		try {
		    sqlSession.select("board.excel", map, new ResultHandler<BoardDTO>() {
				@Override
				public void handleResult(ResultContext<? extends BoardDTO> context) { 
				    BoardDTO dto = context.getResultObject();
				    SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				    Row row = sheet.createRow(context.getResultCount() - 1);
			    	Cell cell = null;
			    	cell = row.createCell(0);
			    	cell.setCellValue(dto.getIdx());
			        cell = row.createCell(1);
			        cell.setCellValue(dto.getB_subject());
			        cell = row.createCell(2);
			        cell.setCellValue(dto.getB_writer());
			        cell = row.createCell(3);
			        cell.setCellValue(dto.getB_readcount());
			        cell = row.createCell(4);
			        cell.setCellValue(date.format(dto.getB_date()));
			    }
            }); 
		
			response.setHeader("Set-Cookie", "fileDownload=true; path=/");
			response.setHeader("Content-Disposition", String.format("attachment; filename=\"list.xlsx\""));
			wb.write(response.getOutputStream());
		

		} catch(Exception e) {
			response.setHeader("Set-Cookie", "fileDownload=false; path=/");
			response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
			response.setHeader("Content-Type","text/html; charset=utf-8");
			
			OutputStream out = null;
			try {
				out = response.getOutputStream();
				byte[] data = new String("fail..").getBytes();
				out.write(data, 0, data.length);
			} catch(Exception ignore) {
				ignore.printStackTrace();
			} finally {
				if(out != null) try { out.close(); } catch(Exception ignore) {}
			}
			
		} finally {
			
			// 디스크 적었던 임시파일을 제거합니다.
			wb.dispose();
			
			try { wb.close(); } catch(Exception ignore) {}
		}
	}

}
