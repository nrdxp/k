// Copyright (c) 2014 K Team. All Rights Reserved.
package org.kframework.backend.java.builtins;


import org.kframework.backend.java.kil.*;
import org.kframework.backend.java.kil.Term;
import org.kframework.backend.java.kil.Variable;
import org.kframework.backend.java.symbolic.UserSubstitutionTransformer;

import java.util.HashMap;
import java.util.Map;

/**
 * Table of {@code public static} methods on builtin user-level substitution.
 *
 * @author: TraianSF
 */
public class BuiltinSubstitutionOperations {

    public static Term userSubstitution(Term term, Term substitute, Term variable, TermContext context) {
        Map<Term, Term> substitution = new HashMap<>();
        substitution.put(variable, substitute);
        UserSubstitutionTransformer transformer = new UserSubstitutionTransformer(substitution, context);
        return KLabelInjection.injectionOf((Term) term.accept(transformer), context);
    }

}
