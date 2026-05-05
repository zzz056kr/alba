package com.system.alba.config;

import com.p6spy.engine.logging.Category;
import com.p6spy.engine.spy.appender.MessageFormattingStrategy;
import org.hibernate.engine.jdbc.internal.FormatStyle;

import java.util.Locale;

public class P6SpyFormatter implements MessageFormattingStrategy {

    @Override
    public String formatMessage(int connectionId, String now, long elapsed, String category, String prepared, String sql, String url) {
        if (sql == null || sql.trim().isEmpty()) {
            return "";
        }

        String formattedSql = formatSql(category, sql);

        return String.format(
                "\n[P6Spy] %s | %dms | %s",
                category,
                elapsed,
                formattedSql
        );
    }

    private String formatSql(String category, String sql) {
        if (sql == null || sql.trim().isEmpty()) {
            return sql;
        }

        // DDL (create, alter, drop, comment)
        if (Category.STATEMENT.getName().equals(category)) {
            String trimmedSql = sql.trim().toLowerCase(Locale.ROOT);
            if (trimmedSql.startsWith("create") || trimmedSql.startsWith("alter") ||
                trimmedSql.startsWith("drop") || trimmedSql.startsWith("comment")) {
                return FormatStyle.DDL.getFormatter().format(sql);
            }
        }

        // DML (select, insert, update, delete)
        return FormatStyle.BASIC.getFormatter().format(sql);
    }
}
