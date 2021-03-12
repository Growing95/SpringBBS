package com.ict.controller;

import java.io.File;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.ict.db.BVO;
import com.ict.db.CVO;
import com.ict.db.DAO;
import com.ict.db.MVO;
import com.ict.model.Paging;

@Controller
public class MyController {
	@Autowired
	private DAO dao;
	@Autowired
	private Paging paging;

	public void setPaging(Paging paging) {
		this.paging = paging;
	}

	public void setDao(DAO dao) {
		this.dao = dao;
	}

	@RequestMapping(value = "list.do", method = RequestMethod.GET)
	public ModelAndView listGetCommand(HttpServletRequest request) {
		System.out.println("list:GET");
		String cPage = request.getParameter("cPage");
		ModelAndView mv = listCommand(cPage);
		return mv;
	}

	@RequestMapping(value = "list.do", method = RequestMethod.POST)
	public ModelAndView listPostCommand(@RequestParam("cPage") String cPage) {
		System.out.println("list:POST");
		ModelAndView mv = listCommand(cPage);
		return mv;
	}

	public ModelAndView listCommand(String cPage) {
		ModelAndView mv = new ModelAndView("list");
		// List<BVO> list = dao.getList();

		// 전체 게시물의 수
		int count = dao.getTotalCount();
		paging.setTotalRecord(count);

		// 전체 페이지의 수
		if (paging.getTotalRecord() <= paging.getNumPerPage()) {
			paging.setTotalPage(1);
		} else {
			paging.setTotalPage(paging.getTotalRecord() / paging.getNumPerPage());
			if (paging.getTotalRecord() % paging.getNumPerPage() != 0) {
				paging.setTotalPage(paging.getTotalPage() + 1);
			}
		}

		if (cPage == null) {
			paging.setNowPage(1);
		} else {
			paging.setNowPage(Integer.parseInt(cPage));
		}

		// 시작번호, 끝번호
		paging.setBegin((paging.getNowPage() - 1) * paging.getNumPerPage() + 1);
		paging.setEnd((paging.getBegin() - 1) + paging.getNumPerPage());
		List<BVO> list = dao.getList2(paging.getBegin(), paging.getEnd());

		// 시작블록, 끝블록
		paging.setBeginBlock(
				(int) ((paging.getNowPage() - 1) / paging.getPagePerBlock()) * paging.getPagePerBlock() + 1);
		paging.setEndBlock(paging.getBeginBlock() + paging.getPagePerBlock() - 1);

		// 주의사항
		if (paging.getEndBlock() > paging.getTotalPage()) {
			paging.setEndBlock(paging.getTotalPage());
		}

		mv.addObject("list", list);
		mv.addObject("paging", paging);

		return mv;
	}

	@RequestMapping("login_ok.do")
	public ModelAndView logInOKCommand(MVO m_vo, HttpServletRequest request) {
		MVO mvo = dao.getLogin(m_vo);
		if (mvo == null) {
			request.getSession().setAttribute("login", "no");
		} else {
			request.getSession().setAttribute("login", "ok");
			request.getSession().setAttribute("mvo", mvo);
		}
		return new ModelAndView("redirect:list.do");
	}

	@RequestMapping("onelist.do")
	public ModelAndView oneListCommand(@RequestParam("b_idx") String b_idx, @ModelAttribute("cPage") String cPage,
			HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("onelist");

		// 조회수 업데이트
		int result = dao.getHit(b_idx);

		// 상세보기
		BVO bvo = dao.getOneList(b_idx);

		// 세션에 담기
		request.getSession().setAttribute("bvo", bvo);
		System.out.println(bvo.getM_id());
		// 댓글 가져오기
		List<CVO> c_list = dao.getCommList(b_idx);

		mv.addObject("clist", c_list);
		mv.addObject("cPage", cPage);
		return mv;
	}

	@RequestMapping("comm_write.do")
	public ModelAndView comm_WriteCommand(CVO cvo, @RequestParam("cPage") String cPage) {
		ModelAndView mv = new ModelAndView("redirect:onelist.do?b_idx=" + cvo.getB_idx() + "&cPage=" + cPage);
		int result = dao.getc_Insert(cvo);
		return mv;
	}

	@RequestMapping("comm_delete.do")
	public ModelAndView comm_Delete(CVO cvo, @RequestParam("cPage") String cPage) {
		ModelAndView mv = new ModelAndView("redirect:onelist.do?b_idx=" + cvo.getB_idx() + "&cPage=" + cPage);
		int result = dao.getc_Delete(cvo.getC_idx());
		return mv;
	}

	@RequestMapping(value = "write_ok", method = RequestMethod.POST)
	public ModelAndView writeOKCommand(BVO bvo, HttpServletRequest request) {
		try {
			String path = request.getSession().getServletContext().getRealPath("/resources/upload");
			MultipartFile file = bvo.getFile();
			if (file.isEmpty()) {
				bvo.setFile_name("");
			} else {
				bvo.setFile_name(file.getOriginalFilename());
				byte[] in = file.getBytes();
				File out = new File(path, bvo.getFile_name());
				FileCopyUtils.copy(in, out);
			}
			int result = dao.getc_Insert(bvo);
			if (result > 0) {
				return new ModelAndView("redirect:list.do?cPage=1");
			} else {
				return new ModelAndView("redirect:write.do");
			}
		} catch (Exception e) {
			System.out.println("writeok 캐치:"+e);
		}
		return null;
	}

	@RequestMapping("delete_ok.do")
	public ModelAndView deleteOkCommand(@RequestParam("b_idx") String b_idx, @RequestParam("cPage") String cPage) throws Exception {
		int result1 = dao.getc_AllDelete(b_idx);
		int result2 = dao.getDelete(b_idx);
		if (result2 > 0) {
			return new ModelAndView("redirect:list.do?cPage=" + cPage);
		} else {
			return new ModelAndView("redirect:onelist.do?b_idx=" + b_idx + "&cPage=" + cPage);
		}
	}
	
	@RequestMapping(value="update_ok.do", method = RequestMethod.POST)
	public ModelAndView updateOkCommand(BVO bvo, @ModelAttribute("cPage")String cPage, HttpServletRequest request) {
		try {
			String path= request.getSession().getServletContext().getRealPath("/resources/upload");
			MultipartFile file= bvo.getFile();
			String p_filename= request.getParameter("p_filename");
			if (p_filename == null) { // 이전파일없음
				if (file.isEmpty()) { // 이전파일도없고 현재파일도 없고
					bvo.setFile_name("");
				}else {				  // 이전 파일없고 현재파일 있음
					bvo.setFile_name(file.getOriginalFilename());
				}
			}else {					 // 이전파일있음
				if (file.isEmpty()) {				 // 이전파일있고 현재파일없음
					bvo.setFile_name(p_filename);
				}else {				 // 이전파일있고 현재파일로 교체
					bvo.setFile_name(file.getOriginalFilename());
				}
			}
			int result = dao.getUpdate(bvo);
			if (!file.isEmpty()) {
				file.transferTo(new File(path+"/"+bvo.getFile_name()));
			}
			return new ModelAndView("redirect:onelist.do?b_idx="+bvo.getB_idx());
		} catch (Exception e) {
			// TODO: handle exception
		}
		return null;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
