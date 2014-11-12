CREATE TABLE [dbo].[Parametro_Observacao_Nota] (
    [cd_empresa]            INT      NOT NULL,
    [ic_vendedor_nota]      CHAR (1) NULL,
    [ic_tipo_vendedor_nota] CHAR (1) NULL,
    [ic_imprime_corpo_nota] CHAR (1) NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [PK_Parametro_Observacao_Nota] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

