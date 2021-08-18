package com.stjomd.railway.generator.util;

import java.util.Map;

public interface CSVRowOperator {
    void operator(Map<String, String> values);
}
