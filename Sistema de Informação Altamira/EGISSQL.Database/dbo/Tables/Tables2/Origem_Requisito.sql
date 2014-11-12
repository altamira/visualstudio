CREATE TABLE [dbo].[Origem_Requisito] (
    [cd_origem_requisito] INT          NOT NULL,
    [nm_origem_requisito] VARCHAR (40) NULL,
    [sg_origem_requisito] CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Origem_Requisito] PRIMARY KEY CLUSTERED ([cd_origem_requisito] ASC) WITH (FILLFACTOR = 90)
);

