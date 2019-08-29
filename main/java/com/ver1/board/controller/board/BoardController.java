package com.ver1.board.controller.board;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.ver1.board.model.board.Pager;
import com.ver1.board.model.board.dao.BoardDAO;
import com.ver1.board.model.board.dto.BoardDTO;

@Controller
@RequestMapping("board/*")
public class BoardController {

	@Inject
	BoardDAO boardDao;
	
	@RequestMapping("boardlist.do")
	public ModelAndView list(@RequestParam(defaultValue="1") int curPage,
							@RequestParam(defaultValue="") String option,
							@RequestParam(defaultValue="") String keyword,
							ModelAndView mav){
		
		if(keyword.equals("''")) {
			keyword = "";
			
		} else {
			try {
				keyword = URLDecoder.decode(keyword, "UTF-8");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		
		//레코드 갯수 계산
		int b_count = boardDao.b_count(option, "%"+keyword+"%");
		//페이지 관련 설정
		Pager pager = new Pager(b_count, curPage);
		int begin = pager.getPageBegin();
		int end = pager.getPageEnd();
		
		List<BoardDTO> b_list = boardDao.b_list(option, "%"+keyword+"%", begin, end);
		
		HashMap<String, Object> map = new HashMap<>();
		map.put("b_list", b_list);
		map.put("count", b_count);
		map.put("pager", pager);
		map.put("keyword", keyword);
		map.put("option", option);
		
		mav.setViewName("board/boardlist");
		mav.addObject("map", map);
		
		return mav;
	
	}
	
	@RequestMapping("boardwrite.go")
	public String boardwritego() {
		return "board/boardwrite";
	}
	
	@RequestMapping("boardwrite.do")
	public String boardwritedo(@ModelAttribute BoardDTO dto) {
		
		int b_num = boardDao.b_insert(dto);
		
		return "redirect:/board/boardview.go?b_num="+b_num;
	}
	
	@RequestMapping("boardview.go")
	public ModelAndView boardviewgo(@RequestParam int b_num, ModelAndView mav, HttpSession session) {
		
		mav.setViewName("board/boardview");
		mav.addObject("var", boardDao.b_view(b_num, session));
		
		int c_count = boardDao.c_count(b_num);
		mav.addObject("c_count", c_count);
		
		/*
		 * if(c_count > 0) { mav.addObject("war", commentService.c_list(b_num)); }
		 */
		
		return mav;
	}
	
}
