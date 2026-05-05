package com.system.alba.jpa;

import com.google.common.base.CaseFormat;
import org.hibernate.boot.model.naming.Identifier;
import org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl;
import org.hibernate.engine.jdbc.env.spi.JdbcEnvironment;

public class CustomPhysicalStrategy extends PhysicalNamingStrategyStandardImpl {

    @Override
    public Identifier toPhysicalTableName(Identifier name, JdbcEnvironment context) {
        String _name = name.getText();
        String physicalName = _name.startsWith("*") ? _name.substring(1) : "t_" + convertPropertyNameToUnderscoreName(_name);
        return context.getIdentifierHelper().toIdentifier(physicalName);
    }

    @Override
    public Identifier toPhysicalColumnName(Identifier name, JdbcEnvironment context) {
        String _name = name.getText();
        String physicalName = _name.startsWith("*") ? _name.substring(1) : convertPropertyNameToUnderscoreName(_name);

        if ("desc".equalsIgnoreCase(physicalName)) {
            return new Identifier(physicalName, true);  // quoted = true → "`desc`" 로 나감
        }

        return context.getIdentifierHelper().toIdentifier(physicalName);
    }

    private String convertPropertyNameToUnderscoreName(String str) {
        return CaseFormat.LOWER_CAMEL.to(CaseFormat.LOWER_UNDERSCORE, str);
    }

}
