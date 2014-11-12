CREATE TABLE [dbo].[Origem_Caixa] (
    [cd_origem_caixa]        INT          NOT NULL,
    [nm_origem_caixa]        VARCHAR (40) NULL,
    [sg_origem_caixa]        CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [ic_padrao_origem_caixa] CHAR (1)     NULL,
    CONSTRAINT [PK_Origem_Caixa] PRIMARY KEY CLUSTERED ([cd_origem_caixa] ASC) WITH (FILLFACTOR = 90)
);

