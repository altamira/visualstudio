CREATE TABLE [dbo].[Professor] (
    [cd_professor]          INT          NOT NULL,
    [nm_professor]          VARCHAR (40) NULL,
    [nm_fantasia_professor] VARCHAR (15) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Professor] PRIMARY KEY CLUSTERED ([cd_professor] ASC) WITH (FILLFACTOR = 90)
);

