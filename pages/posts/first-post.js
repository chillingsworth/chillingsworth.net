import { Inter } from '@next/font/google'
import styles from '../../styles/Home.module.css'
import Header from '../../components/header'

const inter = Inter({ subsets: ['latin'] })

export default function Post() {

  return (
    <>
      <Header></Header>
      <div className={styles.post_page_body}>
      <div>
        Post #1
      </div>
      <h1>
        First Post Header
      </h1>
      <div className={styles.post_page_text_area}>
        <h3>
          First Post Body
        </h3>
      </div>
    </div>
    </>
  )
}

