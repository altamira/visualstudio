CREATE TABLE [dbo].[Operador] (
    [cd_operador]          INT          NOT NULL,
    [nm_operador]          VARCHAR (40) NOT NULL,
    [nm_fantasia_operador] VARCHAR (15) NOT NULL,
    [cd_chapa_operador]    CHAR (10)    NOT NULL,
    [cd_usuario]           INT          NOT NULL,
    [dt_usuario]           DATETIME     NOT NULL,
    [cd_funcionario]       INT          NULL,
    [vl_encargo_operador]  FLOAT (53)   NULL,
    [vl_hora_operador]     FLOAT (53)   NULL,
    [cd_turno]             INT          NULL,
    [cd_aplicacao_markup]  INT          NULL,
    [cd_barra_operador]    VARCHAR (20) NULL,
    [cd_departamento]      INT          NULL,
    [nm_funcao_operador]   VARCHAR (25) NULL,
    [nm_cargo_operador]    VARCHAR (25) NULL,
    [vl_mensal_operador]   FLOAT (53)   NULL,
    [ic_status_operador]   CHAR (1)     NULL,
    [dt_saida_operador]    DATETIME     NULL,
    CONSTRAINT [PK_Operador] PRIMARY KEY CLUSTERED ([cd_operador] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Operador_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

