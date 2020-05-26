package com.key.dwsurvey.support;

import java.util.HashMap;
import java.util.Map;

/**
 * @author yangye
 * @date 2020/05/24
 */
public class IdMapThreadLocal {

	private static final ThreadLocal<Map<String, String>> tl = new ThreadLocal<Map<String, String>>();

	public static Map<String, String> getIdMap() {
		if (tl.get() == null) {
			Map<String, String> map = new HashMap<String, String>();
			tl.set(map);
			return map;
		}
		return tl.get();
	}

	public static void clear() {
		tl.remove();
	}
}
