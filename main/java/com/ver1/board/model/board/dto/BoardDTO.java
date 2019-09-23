package com.ver1.board.model.board.dto;

import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

public class BoardDTO {
	
	private int b_num;
	private int b_unum;
	private int b_gnum;
	private int b_mnum;
	private String b_writer;
	private String b_pwd;
	private String b_subject;
	private String b_content;
	private String b_filename;
	private byte[] b_blob;
	private MultipartFile[] b_file;
	private long b_filesize;
	private int b_readcount;
	private Date b_date;
	private String b_show;
	private String b_secret;
	private int c_count;
	private int b_count;
	private int idx;
	private int f_count;
	private int f_num;
	public int getB_num() {
		return b_num;
	}
	public void setB_num(int b_num) {
		this.b_num = b_num;
	}
	public int getB_unum() {
		return b_unum;
	}
	public void setB_unum(int b_unum) {
		this.b_unum = b_unum;
	}
	public int getB_gnum() {
		return b_gnum;
	}
	public void setB_gnum(int b_gnum) {
		this.b_gnum = b_gnum;
	}
	public int getB_mnum() {
		return b_mnum;
	}
	public void setB_mnum(int b_mnum) {
		this.b_mnum = b_mnum;
	}
	public String getB_writer() {
		return b_writer;
	}
	public void setB_writer(String b_writer) {
		this.b_writer = b_writer;
	}
	public String getB_pwd() {
		return b_pwd;
	}
	public void setB_pwd(String b_pwd) {
		this.b_pwd = b_pwd;
	}
	public String getB_subject() {
		return b_subject;
	}
	public void setB_subject(String b_subject) {
		this.b_subject = b_subject;
	}
	public String getB_content() {
		return b_content;
	}
	public void setB_content(String b_content) {
		this.b_content = b_content;
	}
	public String getB_filename() {
		return b_filename;
	}
	public void setB_filename(String b_filename) {
		this.b_filename = b_filename;
	}
	public byte[] getB_blob() {
		return b_blob;
	}
	public void setB_blob(byte[] b_blob) {
		this.b_blob = b_blob;
	}
	public MultipartFile[] getB_file() {
		return b_file;
	}
	public void setB_file(MultipartFile[] b_file) {
		this.b_file = b_file;
	}
	public long getB_filesize() {
		return b_filesize;
	}
	public void setB_filesize(long b_filesize) {
		this.b_filesize = b_filesize;
	}
	public int getB_readcount() {
		return b_readcount;
	}
	public void setB_readcount(int b_readcount) {
		this.b_readcount = b_readcount;
	}
	public Date getB_date() {
		return b_date;
	}
	public void setB_date(Date b_date) {
		this.b_date = b_date;
	}
	public String getB_show() {
		return b_show;
	}
	public void setB_show(String b_show) {
		this.b_show = b_show;
	}
	public String getB_secret() {
		return b_secret;
	}
	public void setB_secret(String b_secret) {
		this.b_secret = b_secret;
	}
	public int getC_count() {
		return c_count;
	}
	public void setC_count(int c_count) {
		this.c_count = c_count;
	}
	public int getB_count() {
		return b_count;
	}
	public void setB_count(int b_count) {
		this.b_count = b_count;
	}
	public int getIdx() {
		return idx;
	}
	public void setIdx(int idx) {
		this.idx = idx;
	}
	public int getF_count() {
		return f_count;
	}
	public void setF_count(int f_count) {
		this.f_count = f_count;
	}
	public int getF_num() {
		return f_num;
	}
	public void setF_num(int f_num) {
		this.f_num = f_num;
	}
	
}
