CREATE TABLE [dbo].[SeqUsinagem] (
    [cd_sequsinagem] INT          NOT NULL,
    [nm_usinagem]    VARCHAR (40) NOT NULL,
    [sg_usinagem]    CHAR (10)    NOT NULL,
    [cd_usuario]     INT          NOT NULL,
    [dt_usuario]     DATETIME     NOT NULL,
    CONSTRAINT [PK_SeqUsinagem] PRIMARY KEY CLUSTERED ([cd_sequsinagem] ASC) WITH (FILLFACTOR = 90)
);

