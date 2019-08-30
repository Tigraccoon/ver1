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
		
		//제목, 이름 특수문자처리
		for(BoardDTO dto : b_list) {
			String b_subject = dto.getB_subject();
			
			b_subject = b_subject.replace("<", "&lt;");
			b_subject = b_subject.replace(">", "&gt;");
			b_subject = b_subject.replace("\n", "<br>");
			b_subject = b_subject.replace("  ", "&nbsp;&nbsp;");
			
			dto.setB_subject(b_subject);
			
			String b_writer = dto.getB_writer();
			
			b_writer = b_writer.replace("<", "&lt;");
			b_writer = b_writer.replace(">", "&gt;");
			b_writer = b_writer.replace("\n", "<br>");
			b_writer = b_writer.replace("  ", "&nbsp;&nbsp;");
			
			dto.setB_writer(b_writer);
		}
		
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
		
		BoardDTO dto = boardDao.b_view(b_num, session);
		
		String b_subject = dto.getB_subject();
		
		b_subject = b_subject.replace("<", "&lt;");
		b_subject = b_subject.replace(">", "&gt;");
		b_subject = b_subject.replace("\n", "<br>");
		b_subject = b_subject.replace("  ", "&nbsp;&nbsp;");
		
		dto.setB_subject(b_subject);
		
		String b_writer = dto.getB_writer();
		
		b_writer = b_writer.replace("<", "&lt;");
		b_writer = b_writer.replace(">", "&gt;");
		b_writer = b_writer.replace("\n", "<br>");
		b_writer = b_writer.replace("  ", "&nbsp;&nbsp;");
		
		dto.setB_writer(b_writer);
		
		mav.addObject("var", dto);
		
		int c_count = boardDao.c_count(b_num);
		mav.addObject("c_count", c_count);
		
		/*
		 * if(c_count > 0) { mav.addObject("war", commentService.c_list(b_num)); }
		 */
		
		return mav;
	}
	
	
	@RequestMapping("b_update.go")
	public ModelAndView updatego(@ModelAttribute BoardDTO dto, ModelAndView mav, HttpSession session) {
		
		BoardDTO tempdto = boardDao.b_view(dto.getB_num(), session);
		
		String b_subject = tempdto.getB_subject();
		
		b_subject = b_subject.replace("<", "&lt;");
		b_subject = b_subject.replace(">", "&gt;");
		b_subject = b_subject.replace("\n", "<br>");
		b_subject = b_subject.replace("  ", "&nbsp;&nbsp;");
		
		tempdto.setB_subject(b_subject);
		
		String b_writer = tempdto.getB_writer();
		
		b_writer = b_writer.replace("<", "&lt;");
		b_writer = b_writer.replace(">", "&gt;");
		b_writer = b_writer.replace("\n", "<br>");
		b_writer = b_writer.replace("  ", "&nbsp;&nbsp;");
		
		tempdto.setB_writer(b_writer);
		
		mav.addObject("var", tempdto);
		
		boolean result = boardDao.pwdcheck(dto);
		
		if(result) {
			mav.setViewName("board/boardupdel");
		} else {
			mav.setViewName("board/boardview");
			mav.addObject("message", "pwderror");
		}
		
		return mav;
	}
	
	@RequestMapping("boardupdate.do")
	public String bupdatedo(@ModelAttribute BoardDTO dto) {
		
		boardDao.b_update(dto);
		
		return "redirect:/board/boardview.go?b_num=" + dto.getB_num();
	}
	
	@RequestMapping("boarddelete.do")
	public String bdeletedo(@ModelAttribute BoardDTO dto) {
		
		boardDao.b_delete(dto.getB_num());
		
		return "redirect:/";
	}
	
	
}
