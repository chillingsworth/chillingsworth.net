import Head from 'next/head'
import { useRouter } from 'next/router'
import Post from '../../components/post'
import styles from '../../styles/Home.module.css'

const PostId = () => {

  let router= useRouter()

  const { id, header, body} = router.query

  function redirectHome() {   
    router.push('/')
  }

  function redirectAbout() {   
    router.push('/about')
  }


  return (
    <>
      <Head>
        <title>Chillingsworth</title>
        <meta name="description" content="Joshua Killingsworth's Blog" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <main >
        <div className={styles.main_layout}>
          <div className={styles.header_main}>
            <h1 className={styles.header_item} onClick={redirectHome}>
              Chillingsworth 🏖️
            </h1>
            <div className={styles.header_item} onClick={redirectAbout}>
              About
            </div>
          </div>
          <Post id={id} header={header} body={body}/>
        </div>
      </main>
    </>
  )
  
  
}

export default PostId
