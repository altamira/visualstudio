CREATE TABLE [dbo].[SPED_Relacionamento] (
    [cd_relacionamento] INT           NOT NULL,
    [nm_relacionamento] VARCHAR (100) NULL,
    [sg_relacionamento] CHAR (10)     NULL,
    [ds_relacionamento] TEXT          NULL,
    [cd_usuario]        INT           NULL,
    [dt_usuario]        DATETIME      NULL,
    CONSTRAINT [PK_SPED_Relacionamento] PRIMARY KEY CLUSTERED ([cd_relacionamento] ASC)
);

