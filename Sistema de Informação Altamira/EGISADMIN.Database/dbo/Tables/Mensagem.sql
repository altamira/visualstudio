CREATE TABLE [dbo].[Mensagem] (
    [cd_mensagem]         INT          NOT NULL,
    [nm_mensagem]         VARCHAR (40) NULL,
    [ds_mensagem]         TEXT         NULL,
    [cd_gradivade]        INT          NOT NULL,
    [cd_nivel]            INT          NOT NULL,
    [cd_mensagem_sql]     INT          NOT NULL,
    [cd_usuario_atualiza] INT          NULL,
    [dt_atualiza]         DATETIME     NULL,
    [cd_gravidade]        INT          NULL,
    CONSTRAINT [PK_Mensagem] PRIMARY KEY CLUSTERED ([cd_mensagem] ASC) WITH (FILLFACTOR = 90)
);

