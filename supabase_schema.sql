-- ========================================
-- SCHEMA DE BASE DE DATOS PARA FINANZAS APP
-- Supabase PostgreSQL
-- ========================================

-- TABLA: categories (Categorías y subcategorías)
CREATE TABLE IF NOT EXISTS public.categories (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    icon VARCHAR(50) NOT NULL DEFAULT 'category',
    color VARCHAR(7) NOT NULL DEFAULT '#6C63FF',
    type VARCHAR(20) NOT NULL CHECK (type IN ('income', 'expense')),
    parent_id UUID REFERENCES public.categories(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);

-- TABLA: transactions (Transacciones de ingresos y egresos)
CREATE TABLE IF NOT EXISTS public.transactions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    category_id UUID REFERENCES public.categories(id) ON DELETE RESTRICT NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('income', 'expense')),
    amount DECIMAL(15, 2) NOT NULL CHECK (amount > 0),
    description VARCHAR(255),
    notes TEXT,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    attachment_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);

-- TABLA: savings_plans (Planes de ahorro)
CREATE TABLE IF NOT EXISTS public.savings_plans (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    target_amount DECIMAL(15, 2) NOT NULL CHECK (target_amount > 0),
    current_amount DECIMAL(15, 2) DEFAULT 0 CHECK (current_amount >= 0),
    target_date DATE,
    icon VARCHAR(50) DEFAULT 'savings',
    color VARCHAR(7) DEFAULT '#6C63FF',
    is_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);

-- TABLA: budgets (Presupuestos)
CREATE TABLE IF NOT EXISTS public.budgets (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    category_id UUID REFERENCES public.categories(id) ON DELETE RESTRICT NOT NULL,
    limit_amount DECIMAL(15, 2) NOT NULL CHECK (limit_amount > 0),
    spent_amount DECIMAL(15, 2) DEFAULT 0 CHECK (spent_amount >= 0),
    period VARCHAR(20) NOT NULL CHECK (period IN ('daily', 'weekly', 'monthly', 'yearly')),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    notifications_enabled BOOLEAN DEFAULT TRUE,
    warning_threshold DECIMAL(5, 2) DEFAULT 80.0 CHECK (warning_threshold >= 0 AND warning_threshold <= 100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    CONSTRAINT valid_date_range CHECK (end_date > start_date)
);

-- ========================================
-- ÍNDICES PARA MEJORAR EL RENDIMIENTO
-- ========================================

CREATE INDEX idx_categories_user_id ON public.categories(user_id);
CREATE INDEX idx_categories_parent_id ON public.categories(parent_id);
CREATE INDEX idx_categories_type ON public.categories(type);

CREATE INDEX idx_transactions_user_id ON public.transactions(user_id);
CREATE INDEX idx_transactions_category_id ON public.transactions(category_id);
CREATE INDEX idx_transactions_date ON public.transactions(date DESC);
CREATE INDEX idx_transactions_type ON public.transactions(type);

CREATE INDEX idx_savings_plans_user_id ON public.savings_plans(user_id);
CREATE INDEX idx_savings_plans_is_completed ON public.savings_plans(is_completed);

CREATE INDEX idx_budgets_user_id ON public.budgets(user_id);
CREATE INDEX idx_budgets_category_id ON public.budgets(category_id);
CREATE INDEX idx_budgets_is_active ON public.budgets(is_active);

-- ========================================
-- FUNCIONES PARA ACTUALIZAR updated_at
-- ========================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers para actualizar updated_at automáticamente
CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON public.categories
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_transactions_updated_at BEFORE UPDATE ON public.transactions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_savings_plans_updated_at BEFORE UPDATE ON public.savings_plans
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_budgets_updated_at BEFORE UPDATE ON public.budgets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ========================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ========================================

-- Habilitar RLS en todas las tablas
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.savings_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.budgets ENABLE ROW LEVEL SECURITY;

-- Políticas para categories
CREATE POLICY "Users can view their own categories"
    ON public.categories FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own categories"
    ON public.categories FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own categories"
    ON public.categories FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own categories"
    ON public.categories FOR DELETE
    USING (auth.uid() = user_id);

-- Políticas para transactions
CREATE POLICY "Users can view their own transactions"
    ON public.transactions FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own transactions"
    ON public.transactions FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own transactions"
    ON public.transactions FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own transactions"
    ON public.transactions FOR DELETE
    USING (auth.uid() = user_id);

-- Políticas para savings_plans
CREATE POLICY "Users can view their own savings plans"
    ON public.savings_plans FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own savings plans"
    ON public.savings_plans FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own savings plans"
    ON public.savings_plans FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own savings plans"
    ON public.savings_plans FOR DELETE
    USING (auth.uid() = user_id);

-- Políticas para budgets
CREATE POLICY "Users can view their own budgets"
    ON public.budgets FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own budgets"
    ON public.budgets FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own budgets"
    ON public.budgets FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own budgets"
    ON public.budgets FOR DELETE
    USING (auth.uid() = user_id);

-- ========================================
-- CATEGORÍAS PREDETERMINADAS (SEED DATA)
-- ========================================
-- Nota: Estas se insertarán cuando un usuario se registre por primera vez
-- Se puede hacer mediante un trigger o desde la aplicación
