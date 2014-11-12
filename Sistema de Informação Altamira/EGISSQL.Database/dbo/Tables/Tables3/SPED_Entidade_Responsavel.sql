CREATE TABLE [dbo].[SPED_Entidade_Responsavel] (
    [cd_entidade] INT           NOT NULL,
    [nm_entidade] VARCHAR (100) NULL,
    [cd_usuario]  INT           NULL,
    [dt_usuario]  DATETIME      NULL,
    [sg_entidade] CHAR (10)     NULL,
    CONSTRAINT [PK_SPED_Entidade_Responsavel] PRIMARY KEY CLUSTERED ([cd_entidade] ASC)
);

