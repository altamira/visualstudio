CREATE TABLE [dbo].[Fundamento_Legal] (
    [cd_fundamento_legal] INT          NOT NULL,
    [nm_fundamento_legal] VARCHAR (40) NOT NULL,
    [sg_fundamento_legal] CHAR (10)    NOT NULL,
    [cd_siscomex]         INT          NOT NULL,
    [cd_usuario]          INT          NOT NULL,
    [dt_usuario]          DATETIME     NOT NULL,
    CONSTRAINT [PK_Fundamento_Legal] PRIMARY KEY CLUSTERED ([cd_fundamento_legal] ASC) WITH (FILLFACTOR = 90)
);

