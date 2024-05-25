package br.unitins.facelocus.hibernate.functions;

import org.hibernate.boot.model.FunctionContributions;
import org.hibernate.boot.model.FunctionContributor;
import org.hibernate.dialect.function.StandardSQLFunction;
import org.hibernate.type.StandardBasicTypes;

public class UnaccentPsqlFunction implements FunctionContributor {
    @Override
    public void contributeFunctions(FunctionContributions functionContributions) {
        functionContributions.getFunctionRegistry().register(
                "unaccent",
                new StandardSQLFunction("unaccent", StandardBasicTypes.STRING)
        );
    }
}
