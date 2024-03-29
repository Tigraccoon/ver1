package com.ver1.board.controller.board;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.ver1.board.model.board.Pager;
import com.ver1.board.model.board.dao.BoardDAO;
import com.ver1.board.model.board.dao.CommentDAO;
import com.ver1.board.model.board.dao.FileDAO;
import com.ver1.board.model.board.dto.BoardDTO;
import com.ver1.board.model.board.dto.CommentDTO;

@Controller
@RequestMapping("board/*")
public class BoardController {

	@Inject
	BoardDAO boardDao;
	@Inject
	CommentDAO commentDao;
	@Inject
	FileDAO fileDao;
	
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
			
			b_subject = b_subject.replaceAll("&", "&amp;");
			b_subject = b_subject.replaceAll("<", "&lt;");
			b_subject = b_subject.replaceAll(">", "&gt;");
			b_subject = b_subject.replaceAll("\n", "<br>");
			b_subject = b_subject.replaceAll("  ", "&nbsp;&nbsp;");
			
			dto.setB_subject(b_subject);
			
			String b_writer = dto.getB_writer();
			
			b_writer = b_writer.replaceAll("&", "&amp;");
			b_writer = b_writer.replaceAll("<", "&lt;");
			b_writer = b_writer.replaceAll(">", "&gt;");
			b_writer = b_writer.replaceAll("\n", "<br>");
			b_writer = b_writer.replaceAll("  ", "&nbsp;&nbsp;");
			
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
		
		dto.setB_num(b_num);

		
		if(dto.getB_file().length > 1) {
			
			for(int i=0; i < dto.getB_file().length ; i++) {
				dto.setB_filename(dto.getB_file()[i].getOriginalFilename());
				
				try {
					
					byte[] bt = dto.getB_file()[i].getBytes();
					
					dto.setB_blob(bt);
					dto.setB_filesize(bt.length);
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				fileDao.InsertFile(dto);
			}
		}
		
		return "redirect:/board/boardview.go?b_num="+b_num;
	}
	
	@RequestMapping("boardview.go")
	public ModelAndView boardviewgo(@RequestParam int b_num, ModelAndView mav, HttpSession session) {
		
		mav.setViewName("board/boardview");
		
		BoardDTO dto = boardDao.b_view(b_num, session);
		
		String b_subject = dto.getB_subject();
		
		b_subject = b_subject.replaceAll("&", "&amp;");
		b_subject = b_subject.replaceAll("<", "&lt;");
		b_subject = b_subject.replaceAll(">", "&gt;");
		b_subject = b_subject.replaceAll("\n", "<br>");
		b_subject = b_subject.replaceAll("  ", "&nbsp;&nbsp;");
		
		dto.setB_subject(b_subject);
		
		String b_writer = dto.getB_writer();
		
		b_writer = b_writer.replaceAll("&", "&amp;");
		b_writer = b_writer.replaceAll("<", "&lt;");
		b_writer = b_writer.replaceAll(">", "&gt;");
		b_writer = b_writer.replaceAll("\n", "<br>");
		b_writer = b_writer.replaceAll("  ", "&nbsp;&nbsp;");
		
		dto.setB_writer(b_writer);
		
		List<BoardDTO> fdto = fileDao.FileList(b_num);

		if(!fdto.isEmpty()) {
			for(BoardDTO tdto : fdto) {
				tdto.setB_filesize((long)Math.ceil(tdto.getB_filesize() / 1024));
				
			}
		}
		
		
		mav.addObject("far", fdto);
		mav.addObject("var", dto);
		
		int c_count = boardDao.c_count(b_num);
		mav.addObject("c_count", c_count);
		
		
		if(c_count > 0) { 
			List<CommentDTO> cdto = commentDao.c_list(b_num);
			
			for(CommentDTO tcdto : cdto) {
				int i=0;
				
				String tcontent = tcdto.getC_content();
				
				tcontent = tcontent.replaceAll("&", "&amp;");
				tcontent = tcontent.replaceAll("<", "&lt;");
				tcontent = tcontent.replaceAll(">", "&gt;");
				tcontent = tcontent.replaceAll("\n", "<br>");
				tcontent = tcontent.replaceAll("  ", "&nbsp;&nbsp;");
				
				tcdto.setC_content(tcontent);
				
				
				cdto.set(i, tcdto);
				
				i++;
			}
			
			mav.addObject("war", cdto); 
		}
		
		return mav;
	}
	
	
	@RequestMapping("b_update.go")
	public ModelAndView updatego(@ModelAttribute BoardDTO dto, ModelAndView mav, HttpSession session) {
		
		BoardDTO tempdto = boardDao.b_view(dto.getB_num(), session);
		
		boolean result = boardDao.pwdcheck(dto);
		
		if(result) {
			mav.addObject("var", tempdto);
			
			List<BoardDTO> fdto = fileDao.FileList(dto.getB_num());
			
			long f_tsize=0;
			
			for(BoardDTO tdto : fdto) {
				f_tsize += tdto.getB_filesize();
			}
			
			mav.addObject("far", fdto);
			mav.addObject("f_tsize", f_tsize);
			mav.setViewName("board/boardupdel");
		} else {
			String b_subject = tempdto.getB_subject();
			
			b_subject = b_subject.replaceAll("&", "&amp;");
			b_subject = b_subject.replaceAll("<", "&lt;");
			b_subject = b_subject.replaceAll(">", "&gt;");
			b_subject = b_subject.replaceAll("\n", "<br>");
			b_subject = b_subject.replaceAll("  ", "&nbsp;&nbsp;");
			
			tempdto.setB_subject(b_subject);
			
			String b_writer = tempdto.getB_writer();
			
			b_writer = b_writer.replaceAll("&", "&amp;");
			b_writer = b_writer.replaceAll("<", "&lt;");
			b_writer = b_writer.replaceAll(">", "&gt;");
			b_writer = b_writer.replaceAll("\n", "<br>");
			b_writer = b_writer.replaceAll("  ", "&nbsp;&nbsp;");
			
			tempdto.setB_writer(b_writer);
			
			mav.addObject("var", tempdto);
			//mav.addObject("pwd", dto.getB_pwd());
			mav.addObject("message", "pwderror");
			
			mav.setViewName("board/boardview");
		}
		
		return mav;
	}
	
	@RequestMapping("boardupdate.do")
	public String bupdatedo(@ModelAttribute BoardDTO dto) {
		
		if(!dto.getTemp().isEmpty()) {
			
			String[] num = dto.getTemp().split("/");
			
			for(String n : num) {
				fileDao.DelFile(Integer.parseInt(n));
			}
		}
		
		
		if(dto.getB_file().length > 1) {
			
			for(int i=0; i < dto.getB_file().length; i++) {
				
				dto.setB_filename(dto.getB_file()[i].getOriginalFilename());
				try {
					
					byte[] bt = dto.getB_file()[i].getBytes();
					
					dto.setB_blob(bt);
					dto.setB_filesize(bt.length);
					
					fileDao.InsertFile(dto);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
				
		}
		
		boardDao.b_update(dto);
		
		return "redirect:/board/boardview.go?b_num=" + dto.getB_num();
	}
	
	@RequestMapping("boarddelete.do")
	public String bdeletedo(@ModelAttribute BoardDTO dto) {
		
		boardDao.b_delete(dto.getB_num(), dto.getB_mnum());

		return "redirect:/";
	}
	
	@RequestMapping("c_insert.do")
	public String commentinsertdo(@ModelAttribute CommentDTO dto) {
		
		commentDao.c_insert(dto);
		
		return "redirect:/board/boardview.go?b_num="+dto.getB_num();
	}
	
	@RequestMapping("c_update.do")
	public String commentupdatedo(@ModelAttribute CommentDTO dto) {
		
		commentDao.c_update(dto);
		
		return "redirect:/board/boardview.go?b_num="+dto.getB_num();
	}
	
	@RequestMapping("c_delete.do")
	public String commentdeletedo(@RequestParam int c_num, @RequestParam int b_num) {
		commentDao.c_delete(c_num);
		
		return "redirect:/board/boardview.go?b_num="+b_num;
	}
	
	@RequestMapping("boardreple.go")
	public ModelAndView boardreplego(@RequestParam int b_num, ModelAndView mav) {
		
		BoardDTO dto = boardDao.b_getupperinfo(b_num);
		
		mav.setViewName("board/boardre");
		mav.addObject("var", dto);

		List<BoardDTO> fdto = fileDao.FileList(dto.getB_num());
		
		long f_tsize=0;
		
		for(BoardDTO tdto : fdto) {
			f_tsize += tdto.getB_filesize();
		}
		
		mav.addObject("far", fdto);
		mav.addObject("f_tsize", f_tsize);
		
		return mav;
	}
	
	@RequestMapping("boardrewrite.do")
	public String boardrewritedo(@ModelAttribute BoardDTO dto){
		
		int b_num = boardDao.b_reinsert(dto);
		
		dto.setB_num(b_num);
		
		if(dto.getB_file().length > 1) {
			
			for(int i=0; i< dto.getB_file().length; i++) {
				
				dto.setB_filename(dto.getB_file()[i].getOriginalFilename());
				
				try {
					
					byte[] bt = dto.getB_file()[i].getBytes();
					
					dto.setB_blob(bt);
					dto.setB_filesize(bt.length);
					
					fileDao.InsertFile(dto);
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}
		}
		
		
		return "redirect:/board/boardview.go?b_num="+b_num;
	}
	
	@RequestMapping("filedown.do")
	public void filedowndo(@RequestParam int f_num, HttpServletResponse response) throws Exception {
		
		BoardDTO dto = fileDao.FileInfo(f_num);
		
		response.setContentType("application/octet-stream");
		response.setContentLength((int)dto.getB_filesize());
		response.setHeader("Content-Disposition", "attachment; fileName=\"" + URLEncoder.encode(dto.getB_filename(),"UTF-8")+"\";");
		response.setHeader("Content-Transfer-Encoding", "binary");
		response.getOutputStream().write(dto.getB_blob());
		response.getOutputStream().flush();
		response.getOutputStream().close();
		
	}
	
	@RequestMapping("excel.do")
	public void exceldo(HttpServletResponse response) throws Exception {
		boardDao.excel(response);
	}
	
}
