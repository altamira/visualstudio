CREATE TABLE [dbo].[Tipo_Prioridade] (
    [cd_tipo_prioridade]     INT          NOT NULL,
    [nm_tipo_prioridade]     VARCHAR (30) NOT NULL,
    [sg_tipo_prioridade]     CHAR (10)    NOT NULL,
    [cd_imagem]              INT          NOT NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    [ic_pad_tipo_prioridade] CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Prioridade] PRIMARY KEY CLUSTERED ([cd_tipo_prioridade] ASC) WITH (FILLFACTOR = 90)
);

