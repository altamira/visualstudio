CREATE TABLE [dbo].[Funcao_Pos] (
    [cd_funcao_pos]      INT          NOT NULL,
    [nm_funcao_pos]      VARCHAR (50) NULL,
    [sg_funcao_pos]      CHAR (20)    NULL,
    [ic_funcao_pos]      CHAR (1)     NULL,
    [ds_funcao_pos]      TEXT         NULL,
    [ds_parametro_pos]   TEXT         NULL,
    [ic_converte_pos]    CHAR (1)     NULL,
    [ic_retorno_qry_pos] CHAR (1)     NULL,
    [ic_procedure_pos]   CHAR (1)     NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Funcao_Pos] PRIMARY KEY CLUSTERED ([cd_funcao_pos] ASC) WITH (FILLFACTOR = 90)
);

