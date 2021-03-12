package com.ict.db;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

public class DAO {
	private SqlSessionTemplate sqlSessionTemplate;
	private DataSourceTransactionManager transManager;

	public void setSqlSessionTemplate(SqlSessionTemplate sqlSessionTemplate) {
		this.sqlSessionTemplate = sqlSessionTemplate;
	}
	// delete 했을 때 댓글이 있으면 삭제가 안됨.
	// 이때 트랜젝션 처리를 해야 된다.

	// 페이징 기법 전
	/*
	 * public List<BVO> getList() { List<BVO> list = null; list =
	 * sqlSessionTemplate.selectList("list"); return list; }
	 */
	// 페이징 기법 후
	public List<BVO> getList2(int begin, int end) {
		List<BVO> list = null;
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("begin", begin);
		map.put("end", end);
		list = sqlSessionTemplate.selectList("list2", map);
		return list;
	}

	public void setTransManager(DataSourceTransactionManager transManager) {
		this.transManager = transManager;
	}

	public MVO getLogin(MVO m_vo) {
		MVO mvo = null;
		mvo = sqlSessionTemplate.selectOne("login", m_vo);
		return mvo;

	}

	public int getTotalCount() {
		int result = 0;
		result = sqlSessionTemplate.selectOne("count");
		return result;
	}

	public int getHit(String b_idx) {
		int result = 0;
		result = sqlSessionTemplate.update("hitup", b_idx);
		return result;
	}

	public BVO getOneList(String b_idx) {
		BVO bvo = null;
		bvo = sqlSessionTemplate.selectOne("onelist", b_idx);
		return bvo;
	}

	public List<CVO> getCommList(String b_idx) {
		List<CVO> list = null;
		list = sqlSessionTemplate.selectList("clist", b_idx);
		return list;
	}

	public int getc_Insert(CVO cvo) {
		int result = 0;
		result = sqlSessionTemplate.insert("c_insert", cvo);
		return result;
	}

	public int getc_Delete(String c_idx) {
		int result = 0;
		result = sqlSessionTemplate.delete("c_delete", c_idx);
		return result;
	}

	public int getc_Insert(BVO bvo) {
		int result = 0;
		result = sqlSessionTemplate.insert("insert", bvo);
		return result;
	}

	public int getc_AllDelete(String b_idx) {
		int result = 0;
		result = sqlSessionTemplate.delete("c_delete_all", b_idx);
		return result;
	}

	public int getDelete(String b_idx) throws Exception {
		int result = 0;
		result = sqlSessionTemplate.delete("delete", b_idx);
		return result;
	}
	public int getUpdate(BVO bvo) {
		int result=0;
		result=sqlSessionTemplate.update("update", bvo);
		return result;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}