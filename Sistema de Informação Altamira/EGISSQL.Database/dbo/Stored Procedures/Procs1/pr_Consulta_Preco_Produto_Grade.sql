
CREATE PROCEDURE pr_Consulta_Preco_Produto_Grade

  @ic_parametro int, -- 1 - Define se irá tratar os dados para consulta/edição
                     -- 2 - Realiza a busca da grade de produto que se adequa aos valores definidos
  @cd_produto integer, --Código do produto
  @qt_inicio_produto_grade float,
  @qt_final_produto_grade  float

AS

declare @nm_produto_grade_final varchar(255),--Descrição final por cd_produto_grade
        @nm_produto_grade varchar(40),
        @nm_titulo_produto_grade varchar(40),
        @cd_produto_grade int,
        @vl_produto_grade numeric(18,2),
        @vl_custo_produto_grade numeric(18,2),
        @qt_inicio_produto_grade_aux numeric(18,2),
        @qt_final_produto_grade_aux numeric(18,2),
        @qt_inicio_produto_grade_primeira numeric(18,2),
        @qt_final_produto_grade_primeira numeric(18,2),
        @qt_inicio_produto_grade_segunda numeric(18,2),
        @qt_final_produto_grade_segunda numeric(18,2)


/*=============================================================
Verifica se o retorno deve ser para edição, istó é, 
todos os preços vinculados as grades do produto ou se a grade
que se encaixa com os valores informados
=============================================================*/

if @ic_parametro = 1
begin
/*=============================================================
Consulta todas as grades do produto
=============================================================*/

    --Gera a tabela de armazenagem das informações
    Select distinct cd_produto_grade,
           @cd_produto as cd_produto,
           cast('' as varchar(255)) as nm_produto_grade,
           cast(0 as numeric(18,2)) as vl_produto_grade,
           cast(0 as numeric(18,2)) as vl_custo_produto_grade,
           1 as cd_usuario,
           getdate() as dt_usuario
    into        
        #Produto_Grade_Preco
    from 
        Produto_Grade 
    where 
        cd_produto = @cd_produto

    --Gerar o descritivo para o nome da grade
    declare cursor_grade cursor for
    Select cd_produto_grade from #Produto_Grade_Preco order by cd_produto_grade

    open cursor_grade
    Fetch next from cursor_grade into @cd_produto_grade
    
    --Inicializa descrições para geração
    set @nm_produto_grade_final = ''
    while @@FETCH_STATUS = 0
    begin
        declare cursor_grade_insert cursor for
        Select 
            isNull((Select top 1 nm_tipo_grade from Tipo_Grade where cd_tipo_grade = pg.cd_tipo_grade),'') as nm_produto_grade, 
            IsNull(nm_titulo_produto_grade,'')
        from 
            Produto_Grade pg
        where 
            cd_produto_grade = @cd_produto_grade
            and 
            cd_produto = @cd_produto
        order by cd_produto_grade
            
        open cursor_grade_insert
        Fetch next from cursor_grade_insert into @nm_produto_grade, @nm_titulo_produto_grade

        WHILE @@FETCH_STATUS = 0
        Begin
            if @nm_produto_grade_final <> ''
               set @nm_produto_grade_final = @nm_produto_grade_final + ' - ' + @nm_produto_grade + ': "' + @nm_titulo_produto_grade + '"'
            else
               set @nm_produto_grade_final = @nm_produto_grade + ': "' + @nm_titulo_produto_grade + '"'
            Fetch next from cursor_grade_insert into @nm_produto_grade, @nm_titulo_produto_grade            
        end
        CLOSE cursor_grade_insert
        DEALLOCATE cursor_grade_insert 

        --Zera valor para ser preenchido
        set @vl_produto_grade       = 0
        set @vl_custo_produto_grade = 0
              

        --Atualiza os valores com os já cadastrados na tabela Produto_Grade_Preco
        Select top 1
              @vl_produto_grade       = vl_produto_grade,
              @vl_custo_produto_grade = vl_custo_produto_grade
        From
              Produto_Grade_Preco
        Where 
            cd_produto_grade = @cd_produto_grade
        
        --Atualiza a tabela final        
        Update 
            #Produto_Grade_Preco
        set 
            nm_produto_grade       = @nm_produto_grade_final,
            vl_produto_grade       = @vl_produto_grade,
            vl_custo_produto_grade = @vl_custo_produto_grade
        where
            cd_produto_grade = @cd_produto_grade

        set @nm_produto_grade_final = ''
        Fetch next from cursor_grade into @cd_produto_grade
    end    
    CLOSE cursor_grade
    DEALLOCATE cursor_grade 
   Select * from #Produto_Grade_Preco           
   drop table #Produto_Grade_Preco           
end
else
begin
/*=============================================================
Consulta a grade que se encaixa com os valores informados
=============================================================*/
/*=============================================================
Consulta as grades de produto dentro do limite informado
=============================================================*/

    --Gera a tabela de armazenagem das informações
    Select distinct cd_produto_grade,
           @cd_produto as cd_produto,
           cast('' as varchar(255)) as nm_produto_grade,
           cast(0 as numeric(18,2)) as vl_produto_grade,
           cast(0 as numeric(18,2)) as vl_custo_produto_grade,
           cast(0 as numeric(18,2)) as qt_inicio_produto_grade_primeira,
           cast(0 as numeric(18,2)) as qt_final_produto_grade_primeira,
           cast(0 as numeric(18,2)) as qt_inicio_produto_grade_segunda,
           cast(0 as numeric(18,2)) as qt_final_produto_grade_segunda,
           1 as cd_usuario,
           getdate() as dt_usuario
    into        
        #Produto_Grade_Preco_Filtrada
    from 
        Produto_Grade 
    where 
        cd_produto = @cd_produto

    --Gerar o descritivo para o nome da grade
    declare cursor_grade cursor for
    Select cd_produto_grade from #Produto_Grade_Preco_Filtrada order by cd_produto_grade

    
    open cursor_grade
    Fetch next from cursor_grade into @cd_produto_grade
     
    --Inicializa descrições para geração
    set @nm_produto_grade_final = ''
    while @@FETCH_STATUS = 0
    begin
        declare cursor_grade_insert cursor for
        Select 
            isNull((Select top 1 nm_tipo_grade from Tipo_Grade where cd_tipo_grade = pg.cd_tipo_grade),'') as nm_produto_grade, 
            IsNull(nm_titulo_produto_grade,''),
            qt_inicio_produto_grade,
            qt_final_produto_grade
        from 
            Produto_Grade pg
        where 
            cd_produto_grade = @cd_produto_grade
            and 
            cd_produto = @cd_produto           
        order by cd_produto_grade

         
        open cursor_grade_insert
        Fetch next from cursor_grade_insert into @nm_produto_grade, @nm_titulo_produto_grade, @qt_inicio_produto_grade_aux, @qt_final_produto_grade_aux

        WHILE @@FETCH_STATUS = 0
        Begin
            if @nm_produto_grade_final <> ''
            begin
               set @nm_produto_grade_final = @nm_produto_grade_final + ' - ' + @nm_produto_grade + ': "' + @nm_titulo_produto_grade + '"'
               set @qt_inicio_produto_grade_segunda = @qt_inicio_produto_grade_aux
               set @qt_final_produto_grade_segunda  = @qt_final_produto_grade_aux
            end
            else
            begin
               set @nm_produto_grade_final = @nm_produto_grade + ': "' + @nm_titulo_produto_grade + '"'
               set @qt_inicio_produto_grade_primeira = @qt_inicio_produto_grade_aux
               set @qt_final_produto_grade_primeira  = @qt_final_produto_grade_aux
            end
            Fetch next from cursor_grade_insert into @nm_produto_grade, @nm_titulo_produto_grade, @qt_inicio_produto_grade_aux, @qt_final_produto_grade_aux
        end
        CLOSE cursor_grade_insert
        DEALLOCATE cursor_grade_insert 

        --Zera valor para ser preenchido
        set @vl_produto_grade       = 0
        set @vl_custo_produto_grade = 0
              

        --Atualiza os valores com os já cadastrados na tabela Produto_Grade_Preco
        Select top 1
              @vl_produto_grade       = vl_produto_grade,
              @vl_custo_produto_grade = vl_custo_produto_grade
        From
              Produto_Grade_Preco
        Where 
            cd_produto_grade = @cd_produto_grade

        --Atualiza a tabela final        
        Update 
            #Produto_Grade_Preco_Filtrada
        set 
            nm_produto_grade                   = @nm_produto_grade_final,
            vl_produto_grade                   = @vl_produto_grade,
            vl_custo_produto_grade             = @vl_custo_produto_grade,
            qt_inicio_produto_grade_primeira   = @qt_inicio_produto_grade_primeira,
            qt_final_produto_grade_primeira    = @qt_final_produto_grade_primeira,
            qt_inicio_produto_grade_segunda    = @qt_inicio_produto_grade_segunda,
            qt_final_produto_grade_segunda     = @qt_final_produto_grade_segunda
        where
            cd_produto_grade = @cd_produto_grade

        set @nm_produto_grade_final = ''
        Fetch next from cursor_grade into @cd_produto_grade
    end    
    CLOSE cursor_grade
    DEALLOCATE cursor_grade 

    if (@qt_final_produto_grade <> 0) and (@qt_inicio_produto_grade <> 0)
        Select cd_produto_grade,
               @cd_produto as cd_produto,
               nm_produto_grade,
               vl_produto_grade,
               vl_custo_produto_grade,
               cd_usuario,
               dt_usuario
        from 
            #Produto_Grade_Preco_Filtrada
        where 
            (qt_inicio_produto_grade_primeira <= @qt_inicio_produto_grade  and
            qt_final_produto_grade_primeira  >= @qt_inicio_produto_grade)  and
            (qt_inicio_produto_grade_segunda  <= @qt_final_produto_grade and
            qt_final_produto_grade_segunda   >= @qt_final_produto_grade)
    else if (@qt_final_produto_grade = 0) and (@qt_inicio_produto_grade <> 0)
        Select cd_produto_grade,
               @cd_produto as cd_produto,
               nm_produto_grade,
               vl_produto_grade,
               vl_custo_produto_grade,
               cd_usuario,
               dt_usuario
        from 
            #Produto_Grade_Preco_Filtrada
        where 
            (qt_inicio_produto_grade_primeira <= @qt_inicio_produto_grade  and
            qt_final_produto_grade_primeira  >= @qt_inicio_produto_grade)  
    else if (@qt_final_produto_grade <> 0) and (@qt_inicio_produto_grade = 0)
        Select cd_produto_grade,
               @cd_produto as cd_produto,
               nm_produto_grade,
               vl_produto_grade,
               vl_custo_produto_grade,
               cd_usuario,
               dt_usuario
        from 
            #Produto_Grade_Preco_Filtrada
        where 
            (qt_inicio_produto_grade_segunda  <= @qt_final_produto_grade and
            qt_final_produto_grade_segunda   >= @qt_final_produto_grade)

      

    drop table #Produto_Grade_Preco_Filtrada
end
