import Head from 'next/head'
import Image from 'next/image'
import { useRouter } from 'next/router'
import { Inter } from '@next/font/google'
import styles from '@/styles/Home.module.css'

const inter = Inter({ subsets: ['latin'] })

export default function Post(props) {

  
  return (
    <div className={styles.post_page_body}>
      <div>
        Post #{props.id}
      </div>
      <h1>
        {props.header}
      </h1>
      <div className={styles.post_page_text_area}>
        <h3>
          {props.body}
        </h3>
      </div>
    </div>
  )
}
